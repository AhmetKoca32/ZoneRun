import 'package:location/location.dart';

import '../models/polygon_model.dart';

class LocationService {
  final Location _location = Location();
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LatLng? _lastKnownLocation;
  DateTime? _lastLocationTime;

  /// Check and request location permissions
  Future<bool> checkAndRequestPermission() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  /// Get current location (with caching for faster response)
  Future<LatLng?> getCurrentLocation() async {
    try {
      // Return cached location if it's recent (less than 5 seconds old)
      if (_lastKnownLocation != null && _lastLocationTime != null) {
        final age = DateTime.now().difference(_lastLocationTime!);
        if (age.inSeconds < 5) {
          return _lastKnownLocation;
        }
      }
      
      final hasPermission = await checkAndRequestPermission();
      if (!hasPermission) {
        return _lastKnownLocation; // Return cached if available
      }

      final locationData = await _location.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        final location = LatLng(
          latitude: locationData.latitude!,
          longitude: locationData.longitude!,
        );
        _lastKnownLocation = location;
        _lastLocationTime = DateTime.now();
        return location;
      }

      return _lastKnownLocation; // Return cached if new location is invalid
    } catch (e) {
      return _lastKnownLocation; // Return cached on error
    }
  }

  /// Stream location updates (optimized for real-time tracking)
  Stream<LatLng>? getLocationStream() {
    // Configure location settings for real-time tracking (non-blocking)
    _location
        .changeSettings(
          accuracy: LocationAccuracy.high,
          interval: 500, // Update every 500ms for real-time feel
          distanceFilter: 2.0, // Update every 2 meters (reduced from default)
        )
        .ignore();
    
    return _location.onLocationChanged.map((locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        final location = LatLng(
          latitude: locationData.latitude!,
          longitude: locationData.longitude!,
        );
        // Update cache
        _lastKnownLocation = location;
        _lastLocationTime = DateTime.now();
        return location;
      }
      // Return last known location if current is invalid
      return _lastKnownLocation ?? LatLng(latitude: 0.0, longitude: 0.0);
    });
  }

  /// Check if location services are enabled
  Future<bool> isLocationEnabled() async {
    return await _location.serviceEnabled();
  }

  /// Check if permission is granted
  bool hasPermission() {
    return _permissionGranted == PermissionStatus.granted;
  }
}

