class NumberModel {
  final int number;
  final String word;
  final String emoji;
  final String count;

  NumberModel({
    required this.number,
    required this.word,
    required this.emoji,
    required this.count,
  });

  factory NumberModel.fromJson(Map<String, dynamic> json) {
    return NumberModel(
      number: json['number'] as int,
      word: json['word'] as String,
      emoji: json['emoji'] as String,
      count: json['count'] as String,
    );
  }
}
