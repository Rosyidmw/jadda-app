class AyahModel {
  final int id;
  final int surahNumber;
  final int ayahNumber;
  final String arab;
  final String translation;
  final String audioUrl;

  AyahModel({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.arab,
    required this.translation,
    required this.audioUrl,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      id: json['id'] ?? 0,
      surahNumber: json['surah_number'] ?? 0,
      ayahNumber: json['ayah_number'] ?? 0,
      arab: json['arab'] ?? '',
      translation: json['translation'] ?? '',
      audioUrl: json['audio_url'] ?? '',
    );
  }
}
