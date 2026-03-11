import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/polygon_model.dart';
import '../../data/services/map_service.dart';

class MapProvider extends ChangeNotifier {
  final MapService _mapService = MapService();

  /// Ortalama hız için üst sınır (km/s). Bunun üzeri araç kullanımı olarak kabul edilir.
  static const double _maxValidAverageSpeedKmh = 15.0;

  /// Hız hesabı için minimum süre (sn) – çok kısa kayıtların hızını şişirmemek için.
  static const int _minDurationSecondsForSpeedCheck = 60;

  // State
  bool _isTracking = false;
  List<LatLng> _points = [];
  double _currentArea = 0.0;
  LatLng? _currentLocation;
  LatLng? _lastAddedPoint;
  DateTime? _trackingStart;
  StreamSubscription<LatLng>? _locationSubscription;
  bool _canComplete = false;
  String? _errorMessage;
  List<PolygonModel> _savedPolygons = [];
  bool _isInitialized = false;

  // Getters
  bool get isTracking => _isTracking;
  bool get isInitialized => _isInitialized;
  List<LatLng> get points => _points;
  double get currentArea => _currentArea;
  LatLng? get currentLocation => _currentLocation;
  bool get canComplete => _canComplete;
  String? get errorMessage => _errorMessage;
  bool get hasPoints => _points.isNotEmpty;
  List<PolygonModel> get savedPolygons => _savedPolygons;

  /// Start tracking location
  Future<bool> startTracking() async {
    if (_isTracking) return false;

    // Check location permission
    final hasPermission = await _mapService.checkLocationPermission();
    if (!hasPermission) {
      _errorMessage = 'Konum izni gerekli';
      notifyListeners();
      return false;
    }

    // Get initial location
    final initialLocation = await _mapService.getCurrentLocation();
    if (initialLocation == null) {
      _errorMessage = 'Konum alınamadı';
      notifyListeners();
      return false;
    }

    // Reset state
    _points = [initialLocation];
    _lastAddedPoint = initialLocation;
    _currentLocation = initialLocation;
    _currentArea = 0.0;
    _canComplete = false;
    _errorMessage = null;
    _isTracking = true;
    _trackingStart = DateTime.now();

    // Start location stream
    final locationStream = _mapService.startTracking();
    if (locationStream != null) {
      _locationSubscription = locationStream.listen(
        (location) => _handleLocationUpdate(location),
        onError: (_) {
          _errorMessage = 'Konum alınırken hata oluştu. Lütfen tekrar deneyin.';
          notifyListeners();
        },
      );
    }

    notifyListeners();
    return true;
  }

  /// Stop tracking
  void stopTracking() {
    if (!_isTracking) return;

    _isTracking = false;
    _locationSubscription?.cancel();
    _locationSubscription = null;
    _trackingStart = null;

    notifyListeners();
  }

  /// Handle location update with distance filtering (optimized for real-time)
  void _handleLocationUpdate(LatLng location) {
    _currentLocation = location;

    // Always update current location for smooth tracking
    // Check if we should add this point to polygon (minimum distance filter)
    if (_lastAddedPoint != null) {
      final distance = _calculateDistance(_lastAddedPoint!, location);

      // Only add point if distance is greater than minimum (reduced to 2m for real-time)
      if (distance >= AppConstants.minDistanceForNewPoint) {
        _points.add(location);
        _lastAddedPoint = location;
        _updateArea();
        _checkCompletionDistance();
      }
    } else {
      // First point - always add
      _points.add(location);
      _lastAddedPoint = location;
    }

    // Notify listeners immediately for smooth UI updates
    notifyListeners();
  }

  /// Calculate distance between two points (Haversine formula)
  double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // meters

    final lat1Rad = point1.latitude * (math.pi / 180.0);
    final lat2Rad = point2.latitude * (math.pi / 180.0);
    final deltaLat = (point2.latitude - point1.latitude) * (math.pi / 180.0);
    final deltaLon = (point2.longitude - point1.longitude) * (math.pi / 180.0);

    final a =
        math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(deltaLon / 2) *
            math.sin(deltaLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  /// Update polygon area
  void _updateArea() {
    if (_points.length < 3) {
      _currentArea = 0.0;
      return;
    }

    _currentArea = _mapService.calculatePolygonArea(_points);
  }

  /// Check if we're close enough to start point to suggest completion
  void _checkCompletionDistance() {
    if (_points.length < 3) {
      _canComplete = false;
      return;
    }

    final startPoint = _points.first;
    final currentPoint = _points.last;
    final distance = _calculateDistance(startPoint, currentPoint);

    _canComplete = distance <= AppConstants.autoCompleteDistance;
  }

  /// Complete polygon and save to database
  Future<bool> completePolygon(String name) async {
    if (_points.length < 3) {
      _errorMessage = 'En az 3 nokta gerekli';
      notifyListeners();
      return false;
    }

    try {
      // Hız kontrolü: ortalama hız 15 km/s üzerindeyse poligonu geçersiz say
      final now = DateTime.now();
      if (_trackingStart != null && _points.length >= 2) {
        final rawSeconds = now.difference(_trackingStart!).inSeconds;
        final durationSeconds =
            rawSeconds < _minDurationSecondsForSpeedCheck
                ? _minDurationSecondsForSpeedCheck
                : rawSeconds;

        double distanceM = 0.0;
        for (var i = 1; i < _points.length; i++) {
          distanceM += _calculateDistance(_points[i - 1], _points[i]);
        }

        final distanceKm = distanceM / 1000.0;
        if (distanceKm > 0 && durationSeconds > 0) {
          final durationHours = durationSeconds / 3600.0;
          final speedKmh = distanceKm / durationHours;
          if (speedKmh.isFinite && speedKmh > _maxValidAverageSpeedKmh) {
            _errorMessage =
                'Ortalama hızınız ${speedKmh.toStringAsFixed(1)} km/s. '
                'Bu aktivite araçla yapılmış olabilir, bu yüzden alan fethedilmedi.';

            // Takibi sonlandır ve state'i sıfırla
            stopTracking();
            _points = [];
            _currentArea = 0.0;
            _canComplete = false;

            notifyListeners();
            return false;
          }
        }
      }

      // Close polygon by adding first point at the end if not already closed
      if (_points.first.latitude != _points.last.latitude ||
          _points.first.longitude != _points.last.longitude) {
        _points.add(_points.first);
      }

      // Save to database (oluşum başlangıç zamanı ile)
      final polygonId = await _mapService.savePolygon(
        name: name,
        points: _points,
        startedAt: _trackingStart,
      );

      // Mark as completed
      await _mapService.completePolygon(polygonId);

      // Reload saved polygons to show the new one
      await loadSavedPolygons();

      // Reset state
      stopTracking();
      _points = [];
      _currentArea = 0.0;
      _canComplete = false;
      _errorMessage = null;

      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'Bölge kaydedilemedi. Lütfen tekrar deneyin.';
      notifyListeners();
      return false;
    }
  }

  /// Cancel current tracking
  void cancelTracking() {
    stopTracking();
    _points = [];
    _currentArea = 0.0;
    _canComplete = false;
    _errorMessage = null;
    _lastAddedPoint = null;

    notifyListeners();
  }

  /// Add point manually (for testing/emulator)
  void addPointManually(LatLng point) {
    if (!_isTracking) {
      // Start tracking mode if not already tracking
      _isTracking = true;
      _points = [];
      _currentArea = 0.0;
      _canComplete = false;
      _errorMessage = null;
    }

    // Add the point
    _points.add(point);
    _lastAddedPoint = point;
    _currentLocation = point;
    _updateArea();
    _checkCompletionDistance();

    notifyListeners();
  }

  /// Initialize location and load saved polygons
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Mark as initialized immediately (don't wait for location)
      _isInitialized = true;
      notifyListeners();

      // Load location in background with timeout (non-blocking)
      _loadInitialLocation();

      // Load saved polygons in background (non-blocking)
      loadSavedPolygons();
    } catch (_) {
      _errorMessage = 'Harita başlatılamadı. Lütfen tekrar deneyin.';
      notifyListeners();
    }
  }

  /// Load initial location (non-blocking with timeout)
  Future<void> _loadInitialLocation() async {
    try {
      // Use timeout to prevent long waits
      final location = await _mapService.getCurrentLocation().timeout(
        const Duration(seconds: 3),
        onTimeout: () => null,
      );
      if (location != null) {
        _currentLocation = location;
        notifyListeners();
      }
    } catch (e) {
      // Silently fail - location will be loaded when needed
    }
  }

  /// Load saved polygons from database
  Future<void> loadSavedPolygons() async {
    try {
      _savedPolygons = await _mapService.getCompletedPolygons();
      notifyListeners();
    } catch (_) {
      _errorMessage = 'Kayıtlı bölgeler yüklenemedi. Lütfen tekrar deneyin.';
      notifyListeners();
    }
  }

  /// Delete a saved polygon
  Future<bool> deletePolygon(int id) async {
    try {
      await _mapService.deletePolygon(id);
      // Reload polygons to update the list
      await loadSavedPolygons();
      return true;
    } catch (_) {
      _errorMessage = 'Bölge silinemedi. Lütfen tekrar deneyin.';
      notifyListeners();
      return false;
    }
  }

  /// Focus on a specific polygon (for navigation from history page)
  PolygonModel? _polygonToFocus;
  PolygonModel? get polygonToFocus => _polygonToFocus;

  void setPolygonToFocus(PolygonModel? polygon) {
    _polygonToFocus = polygon;
    notifyListeners();
  }

  void clearPolygonToFocus() {
    _polygonToFocus = null;
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }
}
