import 'package:location/location.dart';
import '../models/polygon_model.dart';

class LocationService {
  final Location _location = Location();
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;

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

  /// Get current location
  Future<LatLng?> getCurrentLocation() async {
    try {
      final hasPermission = await checkAndRequestPermission();
      if (!hasPermission) {
        return null;
      }

      final locationData = await _location.getLocation();
      return LatLng(
        latitude: locationData.latitude ?? 0.0,
        longitude: locationData.longitude ?? 0.0,
      );
    } catch (e) {
      return null;
    }
  }

  /// Stream location updates
  Stream<LatLng>? getLocationStream() {
    return _location.onLocationChanged.map((locationData) {
      return LatLng(
        latitude: locationData.latitude ?? 0.0,
        longitude: locationData.longitude ?? 0.0,
      );
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

