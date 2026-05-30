class ArabicVocabularyWord {
  final String word;
  final String emoji;
  final String description;

  ArabicVocabularyWord({
    required this.word,
    required this.emoji,
    required this.description,
  });

  factory ArabicVocabularyWord.fromJson(Map<String, dynamic> json) {
    return ArabicVocabularyWord(
      word: json['word'] as String,
      emoji: json['emoji'] as String,
      description: json['description'] as String,
    );
  }
}

class ArabicVocabularyData {
  final List<ArabicVocabularyWord> animals;
  final List<ArabicVocabularyWord> fruits;
  final List<ArabicVocabularyWord> colors;
  final List<ArabicVocabularyWord> bodyParts;

  ArabicVocabularyData({
    required this.animals,
    required this.fruits,
    required this.colors,
    required this.bodyParts,
  });

  factory ArabicVocabularyData.fromJson(Map<String, dynamic> json) {
    return ArabicVocabularyData(
      animals: (json['animals'] as List)
          .map((e) => ArabicVocabularyWord.fromJson(e as Map<String, dynamic>))
          .toList(),
      fruits: (json['fruits'] as List)
          .map((e) => ArabicVocabularyWord.fromJson(e as Map<String, dynamic>))
          .toList(),
      colors: (json['colors'] as List)
          .map((e) => ArabicVocabularyWord.fromJson(e as Map<String, dynamic>))
          .toList(),
      bodyParts: (json['body_parts'] as List)
          .map((e) => ArabicVocabularyWord.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  List<ArabicVocabularyWord> getCategory(String category) {
    switch (category) {
      case 'animals':
        return animals;
      case 'fruits':
        return fruits;
      case 'colors':
        return colors;
      case 'body_parts':
        return bodyParts;
      default:
        return [];
    }
  }
}
