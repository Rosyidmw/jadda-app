class HadithModel {
  final int id;
  final String arab;
  final String indo;
  final String grade;
  final String takhrij;
  final String? hikmah;

  HadithModel({
    required this.id,
    required this.arab,
    required this.indo,
    required this.grade,
    required this.takhrij,
    this.hikmah,
  });

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    return HadithModel(
      id: json['id'] ?? 0,
      arab: json['text']['ar'] ?? '',
      indo: json['text']['id'] ?? '',
      grade: json['grade'] ?? '',
      takhrij: json['takhrij'] ?? '',
      hikmah: json['hikmah'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': {'ar': arab, 'id': indo},
      'grade': grade,
      'takhrij': takhrij,
      'hikmah': hikmah,
    };
  }
}
