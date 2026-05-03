class SurahModel {
  final int number;
  final String name;
  final String nameLatin;
  final int numberOfAyahs;
  final String translation;
  final String revelation;
  final String description;
  final String audioUrl;

  SurahModel({
    required this.number,
    required this.name,
    required this.nameLatin,
    required this.numberOfAyahs,
    required this.translation,
    required this.revelation,
    required this.description,
    required this.audioUrl,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      nameLatin: json['name_latin'] ?? '',
      numberOfAyahs: json['number_of_ayahs'] ?? 0,
      translation: json['translation'] ?? '',
      revelation: json['revelation'] ?? '',
      description: json['description'] ?? '',
      audioUrl: json['audio_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'name_latin': nameLatin,
      'number_of_ayahs': numberOfAyahs,
      'translation': translation,
      'revelation': revelation,
      'description': description,
      'audio_url': audioUrl,
    };
  }
}
