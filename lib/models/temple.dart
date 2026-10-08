class Temple {
  const Temple({required this.id, required this.name, required this.city,
    required this.district, required this.notes, this.latitude, this.longitude});
  final String id, name, city, district, notes;
  final double? latitude, longitude;
  bool get hasCoordinates => latitude != null && longitude != null;
  factory Temple.fromJson(Map<String, dynamic> json) => Temple(
    id: json['id'] as String, name: json['name'] as String,
    city: json['city'] as String, district: json['district'] as String,
    notes: json['notes'] as String? ?? '',
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble());
}
