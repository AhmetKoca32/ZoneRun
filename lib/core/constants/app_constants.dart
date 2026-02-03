class AppConstants {
  // App Info
  static const String appName = 'ZoneRun';
  
  // Database
  static const String databaseName = 'zone_run.db';
  static const int databaseVersion = 1;
  
  // Map Settings
  static const double defaultZoom = 15.0;
  static const double minZoom = 10.0;
  static const double maxZoom = 20.0;
  
  // Location Settings
  static const double locationAccuracy = 10.0; // meters
  static const int locationUpdateInterval = 1000; // milliseconds
  
  // Polygon Settings
  static const double polygonStrokeWidth = 3.0;
  static const double polygonFillOpacity = 0.2;
  
  // GPS Tracking Settings
  static const double minDistanceForNewPoint =
      2.0; // meters - minimum distance to add new point (reduced for real-time)
  static const double autoCompleteDistance =
      20.0; // meters - distance to start point to suggest completion

  // Profile / Avatars (8 varsayılan; overlay aksesuarlar ileride premiumAvatarStartId 8+)
  static const int avatarCount = 8;
  static String avatarAssetPath(int index) =>
      'assets/avatars/avatar_${index + 1}.png';
}

