class GameLevel {
  final int level;
  final int pairs;
  final String? category;

  GameLevel({
    required this.level,
    required this.pairs,
    this.category,
  });

  factory GameLevel.fromJson(Map<String, dynamic> json) {
    return GameLevel(
      level: json['level'] as int,
      pairs: json['pairs'] as int,
      category: json['category'] as String?,
    );
  }
}

class BalloonLevel {
  final int level;
  final int letters;

  BalloonLevel({
    required this.level,
    required this.letters,
  });

  factory BalloonLevel.fromJson(Map<String, dynamic> json) {
    return BalloonLevel(
      level: json['level'] as int,
      letters: json['letters'] as int,
    );
  }
}

class GameConfig {
  final GameType matching;
  final GameType balloonPop;
  final GameType memory;

  GameConfig({
    required this.matching,
    required this.balloonPop,
    required this.memory,
  });

  factory GameConfig.fromJson(Map<String, dynamic> json) {
    return GameConfig(
      matching: GameType.fromJson(json['matching'] as Map<String, dynamic>),
      balloonPop:
          GameType.fromJson(json['balloon_pop'] as Map<String, dynamic>),
      memory: GameType.fromJson(json['memory'] as Map<String, dynamic>),
    );
  }
}

class GameType {
  final String title;
  final String description;
  final List<dynamic> levels;

  GameType({
    required this.title,
    required this.description,
    required this.levels,
  });

  factory GameType.fromJson(Map<String, dynamic> json) {
    return GameType(
      title: json['title'] as String,
      description: json['description'] as String,
      levels: json['levels'] as List<dynamic>,
    );
  }
}
