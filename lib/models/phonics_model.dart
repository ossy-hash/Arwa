class PhonicsModel {
  final String letter;
  final String sound;
  final String word;
  final String emoji;
  final String phrase;

  PhonicsModel({
    required this.letter,
    required this.sound,
    required this.word,
    required this.emoji,
    required this.phrase,
  });

  factory PhonicsModel.fromJson(Map<String, dynamic> json) {
    return PhonicsModel(
      letter: json['letter'] as String,
      sound: json['sound'] as String,
      word: json['word'] as String,
      emoji: json['emoji'] as String,
      phrase: json['phrase'] as String,
    );
  }
}
