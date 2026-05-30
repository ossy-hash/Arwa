class ShapeModel {
  final String name;
  final String emoji;
  final int sides;
  final String description;

  ShapeModel({
    required this.name,
    required this.emoji,
    required this.sides,
    required this.description,
  });

  factory ShapeModel.fromJson(Map<String, dynamic> json) {
    return ShapeModel(
      name: json['name'] as String,
      emoji: json['emoji'] as String,
      sides: json['sides'] as int,
      description: json['description'] as String,
    );
  }
}
