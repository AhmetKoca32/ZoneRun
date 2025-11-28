class PolygonModel {
  final int? id;
  final String name;
  final List<LatLng> points;
  final double area; // square meters
  final DateTime createdAt;
  final DateTime? completedAt;

  PolygonModel({
    this.id,
    required this.name,
    required this.points,
    required this.area,
    required this.createdAt,
    this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'points': points.map((p) => '${p.latitude},${p.longitude}').join('|'),
      'area': area,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  factory PolygonModel.fromMap(Map<String, dynamic> map) {
    final pointsString = map['points'] as String;
    final points = pointsString
        .split('|')
        .map((p) {
          final coords = p.split(',');
          return LatLng(
            latitude: double.parse(coords[0]),
            longitude: double.parse(coords[1]),
          );
        })
        .toList();

    return PolygonModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      points: points,
      area: map['area'] as double,
      createdAt: DateTime.parse(map['created_at'] as String),
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'] as String)
          : null,
    );
  }

  PolygonModel copyWith({
    int? id,
    String? name,
    List<LatLng>? points,
    double? area,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return PolygonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      points: points ?? this.points,
      area: area ?? this.area,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory LatLng.fromMap(Map<String, dynamic> map) {
    return LatLng(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }
}

