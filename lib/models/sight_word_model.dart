class SightWordModel {
  final String word;
  final String sentence;
  final String emoji;
  final int difficulty;

  SightWordModel({
    required this.word,
    required this.sentence,
    required this.emoji,
    required this.difficulty,
  });

  factory SightWordModel.fromJson(Map<String, dynamic> json) {
    return SightWordModel(
      word: json['word'] as String,
      sentence: json['sentence'] as String,
      emoji: json['emoji'] as String,
      difficulty: json['difficulty'] as int,
    );
  }
}
