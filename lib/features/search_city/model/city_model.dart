class CityModel {
  final String id;
  final String location;

  CityModel({required this.id, required this.location});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(id: json['id'] ?? '', location: json['lokasi']);
  }
}
