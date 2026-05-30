class ArabicAlphabetModel {
  final String letter;
  final String word1;
  final String emoji1;
  final String word2;
  final String emoji2;

  ArabicAlphabetModel({
    required this.letter,
    required this.word1,
    required this.emoji1,
    required this.word2,
    required this.emoji2,
  });

  String get word => word1;
  String get emoji => emoji1;

  factory ArabicAlphabetModel.fromJson(Map<String, dynamic> json) {
    return ArabicAlphabetModel(
      letter: json['letter'] as String,
      word1: json['word1'] as String,
      emoji1: json['emoji1'] as String,
      word2: json['word2'] as String,
      emoji2: json['emoji2'] as String,
    );
  }
}
