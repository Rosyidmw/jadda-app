import 'dart:convert';

class BookmarkModel {
  final int surahNumber;
  final String surahName;
  final int ayahNumber;

  BookmarkModel({
    required this.surahNumber,
    required this.surahName,
    required this.ayahNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'surahNumber': surahNumber,
      'surahName': surahName,
      'ayahNumber': ayahNumber,
    };
  }

  factory BookmarkModel.fromMap(Map<String, dynamic> map) {
    return BookmarkModel(
      surahNumber: map['surahNumber']?.toInt() ?? 0,
      surahName: map['surahName'] ?? '',
      ayahNumber: map['ayahNumber']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookmarkModel.fromJson(String source) =>
      BookmarkModel.fromMap(json.decode(source));
}
