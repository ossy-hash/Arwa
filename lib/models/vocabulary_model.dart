class VocabularyWord {
  final String word;
  final String emoji;
  final String description;

  VocabularyWord({
    required this.word,
    required this.emoji,
    required this.description,
  });

  factory VocabularyWord.fromJson(Map<String, dynamic> json) {
    return VocabularyWord(
      word: json['word'] as String,
      emoji: json['emoji'] as String,
      description: json['description'] as String,
    );
  }
}

class VocabularyData {
  final List<VocabularyWord> animals;
  final List<VocabularyWord> fruits;
  final List<VocabularyWord> colors;
  final List<VocabularyWord> bodyParts;
  final List<VocabularyWord> vegetables;

  VocabularyData({
    required this.animals,
    required this.fruits,
    required this.colors,
    required this.bodyParts,
    required this.vegetables,
  });

  factory VocabularyData.fromJson(Map<String, dynamic> json) {
    return VocabularyData(
      animals: (json['animals'] as List)
          .map((e) => VocabularyWord.fromJson(e as Map<String, dynamic>))
          .toList(),
      fruits: (json['fruits'] as List)
          .map((e) => VocabularyWord.fromJson(e as Map<String, dynamic>))
          .toList(),
      colors: (json['colors'] as List)
          .map((e) => VocabularyWord.fromJson(e as Map<String, dynamic>))
          .toList(),
      bodyParts: (json['body_parts'] as List?)
              ?.map((e) => VocabularyWord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      vegetables: (json['vegetables'] as List?)
              ?.map((e) => VocabularyWord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  List<VocabularyWord> getCategory(String category) {
    switch (category) {
      case 'animals':
        return animals;
      case 'fruits':
        return fruits;
      case 'colors':
        return colors;
      case 'body_parts':
        return bodyParts;
      case 'vegetables':
        return vegetables;
      default:
        return [];
    }
  }
}
