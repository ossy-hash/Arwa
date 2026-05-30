class RewardModel {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final int stars;

  RewardModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.stars,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['id'] as String,
      name: json['name'] as String,
      emoji: json['emoji'] as String,
      description: json['description'] as String,
      stars: json['stars'] as int,
    );
  }
}
