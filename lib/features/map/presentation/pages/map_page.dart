import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/map_styles.dart';
import '../../../../core/extensions/theme_extension_helper.dart';
import '../../../../core/models/polygon_model.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/app_localizations_extra.dart';
import '../../../history/presentation/providers/history_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../data/services/map_service.dart';
import '../providers/map_provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  gmaps.GoogleMapController? _mapController;
  final Set<gmaps.Polyline> _polylines = {};
  final Set<gmaps.Polygon> _polygons = {};
  final Set<gmaps.Marker> _markers = {};
  bool _hasShownCompletionSuggestion = false;
  static const _mapKey = ValueKey('google_map');

  // Camera animation throttling
  LatLng? _lastCenteredLocation;
  DateTime? _lastCameraUpdate;
  bool _isCameraAnimating = false;
  bool _hasFocusedOnPolygon = false;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(gmaps.GoogleMapController controller) {
    _mapController = controller;
    if (!mounted) return;

    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    final mapProvider = Provider.of<MapProvider>(context, listen: false);

    // Set map style immediately (non-blocking, fire and forget)
    _updateMapStyle(profileProvider.isDarkTheme);

    // Initialize provider in background (non-blocking)
    if (!mapProvider.isInitialized) {
      mapProvider.initialize();
    }

    // Load saved polygons in background (non-blocking)
    if (mapProvider.savedPolygons.isEmpty) {
      mapProvider.loadSavedPolygons();
    }

    // Check if there's a polygon to focus on (from history page)
    if (mapProvider.polygonToFocus != null && !_hasFocusedOnPolygon) {
      _hasFocusedOnPolygon = true;
      // Wait a bit for map to be ready, then focus on polygon
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted &&
            _mapController != null &&
            mapProvider.polygonToFocus != null) {
          _focusOnPolygon(mapProvider.polygonToFocus!);
          mapProvider.clearPolygonToFocus();
        }
      });
    } else if (mapProvider.polygonToFocus == null) {
      // Try to focus on location with timeout (non-blocking)
      _focusOnUserLocationWithTimeout(mapProvider);
    }
  }

  Future<void> _focusOnUserLocationWithTimeout(MapProvider? provider) async {
    if (_mapController == null || !mounted) return;

    try {
      LatLng? location;

      // First try to use provider's location (instant)
      if (provider?.currentLocation != null) {
        location = provider!.currentLocation;
      } else {
        // Try to get location with timeout (max 2 seconds)
        final mapService = MapService();
        location = await mapService.getCurrentLocation().timeout(
          const Duration(seconds: 2),
          onTimeout: () => null,
        );
      }

      if (location != null && _mapController != null && mounted) {
        await _mapController!.animateCamera(
          gmaps.CameraUpdate.newLatLngZoom(
            gmaps.LatLng(location.latitude, location.longitude),
            AppConstants.defaultZoom,
          ),
        );
      }
    } catch (e) {
      // Location might not be available, ignore silently
    }
  }

  Future<void> _updateMapStyle(bool isDarkTheme) async {
    if (_mapController == null || !mounted) return;

    final String? mapStyle = isDarkTheme ? MapStyles.darkStyle : null;

    try {
      // Use unawaited to make it non-blocking
      _mapController!.setMapStyle(mapStyle);
    } catch (e) {
      // Controller might be disposed, ignore silently
    }
  }

  void _updateMapPolygon(
    BuildContext context,
    List<LatLng> points,
    List<PolygonModel> savedPolygons,
    MapProvider? provider,
  ) {
    final theme = context.appTheme;
    // Polyline/polygon colors: tema uyumlu (harita stilinde görünür)
    final strokeColor = theme.textPrimary;
    final fillColor = theme.textPrimary.withOpacity(AppConstants.polygonFillOpacity);

    // Convert LatLng to Google Maps LatLng
    final googlePoints = points
        .map((p) => gmaps.LatLng(p.latitude, p.longitude))
        .toList();

    setState(() {
      // Clear and rebuild everything
      _polylines.clear();
      _polygons.clear();
      _markers.clear();

      // Draw polyline for current path (if tracking)
      if (googlePoints.length > 1) {
        _polylines.add(
          gmaps.Polyline(
            polylineId: const gmaps.PolylineId('current_path'),
            points: googlePoints,
            color: strokeColor,
            width: AppConstants.polygonStrokeWidth.toInt(),
          ),
        );
      }

      // Draw current polygon if we have at least 3 points
      if (googlePoints.length >= 3) {
        // Close polygon by adding first point
        final closedPoints = List<gmaps.LatLng>.from(googlePoints);
        if (closedPoints.first.latitude != closedPoints.last.latitude ||
            closedPoints.first.longitude != closedPoints.last.longitude) {
          closedPoints.add(closedPoints.first);
        }

        _polygons.add(
          gmaps.Polygon(
            polygonId: const gmaps.PolygonId('current_polygon'),
            points: closedPoints,
            strokeColor: strokeColor,
            fillColor: fillColor,
            strokeWidth: AppConstants.polygonStrokeWidth.toInt(),
          ),
        );
      }

      // Draw saved polygons (completed ones) — tema accent rengi
      final savedStroke = theme.accent;
      final savedFill = theme.accent.withOpacity(0.3);
      for (final savedPolygon in savedPolygons) {
        if (savedPolygon.points.length >= 3) {
          final savedPoints = savedPolygon.points
              .map((p) => gmaps.LatLng(p.latitude, p.longitude))
              .toList();

          // Ensure polygon is closed
          final closedSavedPoints = List<gmaps.LatLng>.from(savedPoints);
          if (closedSavedPoints.first.latitude !=
                  closedSavedPoints.last.latitude ||
              closedSavedPoints.first.longitude !=
                  closedSavedPoints.last.longitude) {
            closedSavedPoints.add(closedSavedPoints.first);
          }

          _polygons.add(
            gmaps.Polygon(
              polygonId: gmaps.PolygonId('saved_polygon_${savedPolygon.id}'),
              points: closedSavedPoints,
              strokeColor: savedStroke,
              fillColor: savedFill,
              strokeWidth: 3,
            ),
          );
        }
      }

      // Add markers for start and current position (only if tracking)
      if (googlePoints.isNotEmpty) {
        // Start marker
        _markers.add(
          gmaps.Marker(
            markerId: const gmaps.MarkerId('start'),
            position: googlePoints.first,
            icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
              gmaps.BitmapDescriptor.hueGreen,
            ),
            infoWindow: gmaps.InfoWindow(title: AppLocalizations.of(context)!.mapStart),
          ),
        );

        // Current position marker (if different from start)
        if (googlePoints.length > 1) {
          _markers.add(
            gmaps.Marker(
              markerId: const gmaps.MarkerId('current'),
              position: googlePoints.last,
              icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
                gmaps.BitmapDescriptor.hueRed,
              ),
            ),
          );
        }
      }
    });
  }

  void _centerOnLocation(LatLng? location) {
    if (location == null ||
        _mapController == null ||
        !mounted ||
        _isCameraAnimating) {
      return;
    }

    // Check if location has changed significantly (at least 10 meters)
    if (_lastCenteredLocation != null) {
      final distance = _calculateDistance(_lastCenteredLocation!, location);
      if (distance < 10.0) {
        // Location hasn't changed enough, skip update
        return;
      }
    }

    // Throttle camera updates (max once per 500ms)
    final now = DateTime.now();
    if (_lastCameraUpdate != null) {
      final timeSinceLastUpdate = now.difference(_lastCameraUpdate!);
      if (timeSinceLastUpdate.inMilliseconds < 500) {
        // Too soon, skip this update
        return;
      }
    }

    try {
      _isCameraAnimating = true;
      _lastCenteredLocation = location;
      _lastCameraUpdate = now;

      _mapController!
          .animateCamera(
            gmaps.CameraUpdate.newLatLng(
              gmaps.LatLng(location.latitude, location.longitude),
            ),
          )
          .then((_) {
            // Reset animation flag after a short delay
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                _isCameraAnimating = false;
              }
            });
          })
          .catchError((_) {
            // Reset on error
            if (mounted) {
              _isCameraAnimating = false;
            }
          });
    } catch (e) {
      // Controller might be disposed, ignore
      _isCameraAnimating = false;
    }
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

  /// Focus camera on a specific polygon
  Future<void> _focusOnPolygon(PolygonModel polygon) async {
    if (_mapController == null || !mounted || polygon.points.isEmpty) return;

    try {
      // Calculate bounding box of polygon
      double minLat = polygon.points.first.latitude;
      double maxLat = polygon.points.first.latitude;
      double minLon = polygon.points.first.longitude;
      double maxLon = polygon.points.first.longitude;

      for (final point in polygon.points) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLon) minLon = point.longitude;
        if (point.longitude > maxLon) maxLon = point.longitude;
      }

      // Calculate center point
      final centerLat = (minLat + maxLat) / 2;
      final centerLon = (minLon + maxLon) / 2;

      // Calculate appropriate zoom level based on bounding box size
      final latDiff = maxLat - minLat;
      final lonDiff = maxLon - minLon;
      final maxDiff = latDiff > lonDiff ? latDiff : lonDiff;

      double zoom = 15.0; // Default zoom
      if (maxDiff > 0.01) {
        zoom = 13.0; // Large area
      } else if (maxDiff > 0.005) {
        zoom = 14.0; // Medium area
      } else if (maxDiff > 0.001) {
        zoom = 15.0; // Small area
      } else {
        zoom = 16.0; // Very small area
      }

      // Use CameraUpdate.newLatLngBounds for better fit
      try {
        final bounds = gmaps.LatLngBounds(
          southwest: gmaps.LatLng(minLat, minLon),
          northeast: gmaps.LatLng(maxLat, maxLon),
        );

        await _mapController!.animateCamera(
          gmaps.CameraUpdate.newLatLngBounds(bounds, 100.0), // 100px padding
        );
      } catch (e) {
        // Fallback to center and zoom if bounds fails
        await _mapController!.animateCamera(
          gmaps.CameraUpdate.newLatLngZoom(
            gmaps.LatLng(centerLat, centerLon),
            zoom,
          ),
        );
      }
    } catch (e) {
      // Ignore errors
    }
  }

  String _formatArea(double areaInSquareMeters) {
    if (areaInSquareMeters < 10000) {
      // Less than 1 hectare, show in m²
      return '${areaInSquareMeters.toStringAsFixed(0)} m²';
    } else if (areaInSquareMeters < 1000000) {
      // Less than 1 km², show in hectares
      return '${(areaInSquareMeters / 10000).toStringAsFixed(2)} ha';
    } else {
      // 1 km² or more, show in km²
      return '${(areaInSquareMeters / 1000000).toStringAsFixed(2)} km²';
    }
  }

  Future<void> _showCompleteDialog(MapProvider provider) async {
    final theme = context.appTheme;
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<String>(
      context: context,
      barrierColor: theme.primaryBackground.withOpacity(0.7),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.border, width: 1),
          ),
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.accent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.check_circle_outline,
                        color: theme.accent,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                          l10n.mapCompletePolygonTitle,
                            style: TextStyle(
                              color: theme.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                          l10n.mapCompletePolygonSubtitle,
                            style: TextStyle(
                              color: theme.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Area info card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.primaryBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.border, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.mapCompletedAreaLabel,
                            style: TextStyle(
                              color: theme.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatArea(provider.currentArea),
                            style: TextStyle(
                              color: theme.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.accent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${provider.points.length} ${l10n.mapPointsLabel}',
                          style: TextStyle(
                            color: theme.accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Input field
                TextFormField(
                  controller: nameController,
                  autofocus: true,
                  style: TextStyle(
                    color: theme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.mapNameHint,
                    hintStyle: TextStyle(
                      color: theme.textTertiary,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    filled: true,
                    fillColor: theme.primaryBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.border, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.border, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.accent, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.mapNameRequired;
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(context, value.trim());
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: theme.border, width: 1),
                          foregroundColor: theme.textSecondary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.mapCancel,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            Navigator.pop(context, nameController.text.trim());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.accent,
                          foregroundColor: theme.primaryBackground,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          l10n.mapConfirm,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (result != null) {
      final success = await provider.completePolygon(result);
      if (success && mounted) {
        // Geçmiş listesini güncelle ki yeni poligon geçmişte görünsün
        await Provider.of<HistoryProvider>(
          context,
          listen: false,
        ).loadHistory();
        final theme = context.appTheme;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.mapSaved,
              style: TextStyle(color: theme.textPrimary, fontSize: 14),
            ),
            backgroundColor: theme.surface,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (mounted) {
        final theme = context.appTheme;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              provider.errorMessage ?? l10n.mapGenericError,
              style: TextStyle(color: theme.textPrimary, fontSize: 14),
            ),
            backgroundColor: theme.secondaryBackground,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showCancelDialog(BuildContext context, MapProvider provider) {
    final theme = context.appTheme;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierColor: theme.primaryBackground.withOpacity(0.7),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.border, width: 1),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.textSecondary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: theme.textPrimary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.mapTrackingCancelTitle,
                          style: TextStyle(
                            color: theme.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.mapTrackingCancelQuestion,
                          style: TextStyle(
                            color: theme.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Warning message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.textSecondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.textSecondary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: theme.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.mapTrackingCancelWarning,
                        style: TextStyle(
                          color: theme.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Stats info
              if (provider.hasPoints)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.primaryBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.border, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${provider.points.length}',
                            style: TextStyle(
                              color: theme.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(context)!.mapPoint,
                            style: TextStyle(
                              color: theme.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Container(width: 1, height: 40, color: theme.border),
                      Column(
                        children: [
                          Text(
                            _formatArea(provider.currentArea),
                            style: TextStyle(
                              color: theme.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(context)!.mapArea,
                            style: TextStyle(
                              color: theme.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.border, width: 1),
                        foregroundColor: theme.textSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        l10n.mapNo,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        provider.cancelTracking();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.secondaryBackground,
                        foregroundColor: theme.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        l10n.mapYesCancel,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _lastThemeWasDark = false;
  List<LatLng> _lastPoints = [];
  List<PolygonModel> _lastSavedPolygons = [];

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return Consumer2<MapProvider, ProfileProvider>(
      builder: (context, provider, profileProvider, child) {
        // Update map style only when theme changes (and map is already created)
        if (_lastThemeWasDark != profileProvider.isDarkTheme &&
            _mapController != null) {
          _lastThemeWasDark = profileProvider.isDarkTheme;
          // Use microtask for faster execution
          Future.microtask(() {
            if (mounted) {
              _updateMapStyle(profileProvider.isDarkTheme);
            }
          });
        }

        // Update map only when points or saved polygons actually change
        final pointsChanged =
            _lastPoints.length != provider.points.length ||
            (provider.points.isNotEmpty &&
                _lastPoints.isNotEmpty &&
                (_lastPoints.first.latitude != provider.points.first.latitude ||
                    _lastPoints.first.longitude !=
                        provider.points.first.longitude));
        final polygonsChanged =
            _lastSavedPolygons.length != provider.savedPolygons.length;

        if (pointsChanged || polygonsChanged) {
          _lastPoints = List.from(provider.points);
          _lastSavedPolygons = List.from(provider.savedPolygons);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _updateMapPolygon(
                context,
                provider.points,
                provider.savedPolygons,
                provider,
              );

              // Center on current location if tracking (throttled)
              if (provider.isTracking && provider.currentLocation != null) {
                _centerOnLocation(provider.currentLocation);
              }
            }
          });
        }

        // Show completion suggestion (only once)
        if (provider.canComplete &&
            provider.isTracking &&
            !_hasShownCompletionSuggestion) {
          _hasShownCompletionSuggestion = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _showCompletionSuggestion(provider);
            }
          });
        } else if (!provider.canComplete) {
          _hasShownCompletionSuggestion = false;
        }

        // Focus on polygon if requested from history page (only once)
        if (provider.polygonToFocus != null &&
            _mapController != null &&
            !_hasFocusedOnPolygon) {
          final polygon = provider.polygonToFocus!;
          _hasFocusedOnPolygon = true;
          // Use a small delay to ensure map is fully rendered
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted && _mapController != null) {
              _focusOnPolygon(polygon);
              provider.clearPolygonToFocus();
            }
          });
        } else if (provider.polygonToFocus == null) {
          // Reset flag when polygon is cleared
          _hasFocusedOnPolygon = false;
        }

        return Scaffold(
          body: Stack(
            children: [
              // Google Map - Use key to prevent recreation on rebuild
              gmaps.GoogleMap(
                key: _mapKey,
                onMapCreated: _onMapCreated,
                initialCameraPosition: gmaps.CameraPosition(
                  target: provider.currentLocation != null
                      ? gmaps.LatLng(
                          provider.currentLocation!.latitude,
                          provider.currentLocation!.longitude,
                        )
                      : const gmaps.LatLng(
                          39.9334,
                          32.8597,
                        ), // Ankara default (more central in Turkey)
                  zoom: AppConstants.defaultZoom,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                compassEnabled: false,
                mapType: gmaps.MapType.normal,
                polylines: _polylines,
                polygons: _polygons,
                markers: _markers,
                onTap: (gmaps.LatLng position) {
                  // Check if tap is on a saved polygon
                  final tappedPoint = LatLng(
                    latitude: position.latitude,
                    longitude: position.longitude,
                  );
                  final tappedPolygon = _findPolygonAtPoint(
                    tappedPoint,
                    provider.savedPolygons,
                  );

                  if (tappedPolygon != null && tappedPolygon.id != null) {
                    // Show delete dialog for tapped polygon
                    _showDeletePolygonDialog(context, provider, tappedPolygon);
                  }
                  // Removed manual point addition - only GPS tracking is used
                },
              ),

              // Top overlay - Area display
              if (provider.isTracking && provider.hasPoints)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: theme.surface.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.border, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.mapArea,
                              style: TextStyle(
                                color: theme.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatArea(provider.currentArea),
                              style: TextStyle(
                                color: theme.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        if (provider.points.length >= 2)
                          Text(
                            '${provider.points.length} nokta',
                            style: TextStyle(
                              color: theme.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

              // Bottom overlay - Control buttons
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 16,
                left: 16,
                right: 16,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Error message
                    if (provider.errorMessage != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: theme.secondaryBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.border, width: 1),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: theme.textPrimary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                provider.errorMessage!,
                                style: TextStyle(
                                  color: theme.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Control buttons
                    Row(
                      children: [
                        // START/STOP button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (provider.isTracking) {
                                provider.stopTracking();
                              } else {
                                final started = await provider.startTracking();
                                if (started &&
                                    provider.currentLocation != null) {
                                  _centerOnLocation(provider.currentLocation);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: provider.isTracking
                                  ? theme.secondaryBackground
                                  : theme.accent,
                              foregroundColor: theme.primaryBackground,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              provider.isTracking
                                  ? AppLocalizations.of(context)!.mapStop
                                  : AppLocalizations.of(context)!.startButton,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                        ),

                        // Complete button (only when tracking and has points)
                        if (provider.isTracking && provider.hasPoints)
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: ElevatedButton(
                              onPressed: () => _showCompleteDialog(provider),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: provider.canComplete
                                    ? theme.accent
                                    : theme.surface,
                                foregroundColor: provider.canComplete
                                    ? theme.primaryBackground
                                    : theme.textSecondary,
                                padding: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Icon(Icons.check, size: 24),
                            ),
                          ),

                        // Cancel button (only when tracking)
                        if (provider.isTracking)
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: ElevatedButton(
                              onPressed: () =>
                                  _showCancelDialog(context, provider),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.surface,
                                foregroundColor: theme.textSecondary,
                                padding: const EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Icon(Icons.close, size: 24),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCompletionSuggestion(MapProvider provider) {
    final theme = context.appTheme;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: theme.textPrimary, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.mapCompletionSuggestion,
                style: TextStyle(color: theme.textPrimary, fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: theme.surface,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: l10n.mapCompletionAction,
          textColor: theme.accent,
          onPressed: () => _showCompleteDialog(provider),
        ),
      ),
    );
  }

  void _showDeletePolygonDialog(
    BuildContext context,
    MapProvider provider,
    PolygonModel polygon,
  ) {
    final theme = context.appTheme;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierColor: theme.primaryBackground.withOpacity(0.7),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.border, width: 1),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.textSecondary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: theme.textPrimary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.mapDeleteTitle,
                          style: TextStyle(
                            color: theme.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.mapDeleteQuestion,
                          style: TextStyle(
                            color: theme.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Polygon info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.primaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.border, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      polygon.name,
                      style: TextStyle(
                        color: theme.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${l10n.historyAreaLabel}: ${_formatArea(polygon.area)}',
                          style: TextStyle(
                            color: theme.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        if (polygon.completedAt != null)
                          Text(
                            AppLocalizations.of(context)!.mapCompletedAt(_formatDate(polygon.completedAt!)),
                            style: TextStyle(
                              color: theme.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Warning message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.textSecondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.textSecondary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: theme.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.mapDeleteConfirmMessage,
                        style: TextStyle(
                          color: theme.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.border, width: 1),
                        foregroundColor: theme.textSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        l10n.mapCancel,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        if (polygon.id != null) {
                          final success = await provider.deletePolygon(
                            polygon.id!,
                          );
                          if (mounted) {
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(context)!.mapPolygonDeleted,
                                    style: TextStyle(color: theme.textPrimary, fontSize: 14),
                                  ),
                                  backgroundColor: theme.surface,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    provider.errorMessage ?? AppLocalizations.of(context)!.mapErrorOccurred,
                                    style: TextStyle(color: theme.textPrimary, fontSize: 14),
                                  ),
                                  backgroundColor: theme.secondaryBackground,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.secondaryBackground,
                        foregroundColor: theme.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        l10n.mapDeleted,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Check if a point is inside a polygon using ray casting algorithm
  bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
    bool inside = false;
    for (int i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
      final xi = polygon[i].longitude;
      final yi = polygon[i].latitude;
      final xj = polygon[j].longitude;
      final yj = polygon[j].latitude;

      final intersect =
          ((yi > point.latitude) != (yj > point.latitude)) &&
          (point.longitude <
              (xj - xi) * (point.latitude - yi) / (yj - yi) + xi);
      if (intersect) inside = !inside;
    }
    return inside;
  }

  /// Find polygon that contains the tapped point
  PolygonModel? _findPolygonAtPoint(
    LatLng point,
    List<PolygonModel> savedPolygons,
  ) {
    for (final polygon in savedPolygons) {
      if (polygon.points.length >= 3) {
        if (_isPointInPolygon(point, polygon.points)) {
          return polygon;
        }
      }
    }
    return null;
  }
}
