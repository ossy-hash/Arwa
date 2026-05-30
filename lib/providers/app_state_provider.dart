import 'package:flutter/material.dart';
import '../models/reward_model.dart';
import '../utils/local_storage.dart';

class AppStateProvider extends ChangeNotifier {
  int _stars = 0;
  int _coins = 0;
  Set<String> _completedLessons = {};
  Set<String> _earnedBadges = {};
  LocalStorage? _storage;

  int get stars => _stars;
  int get coins => _coins;
  Set<String> get completedLessons => _completedLessons;
  Set<String> get earnedBadges => _earnedBadges;

  Future<void> loadState() async {
    _storage = await LocalStorage.getInstance();
    final data = await _storage!.readAll();
    _stars = data['stars'] as int? ?? 0;
    _coins = data['coins'] as int? ?? 0;
    _completedLessons =
        ((data['completedLessons'] as List<dynamic>?)?.cast<String>() ?? [])
            .toSet();
    _earnedBadges =
        ((data['earnedBadges'] as List<dynamic>?)?.cast<String>() ?? [])
            .toSet();
    notifyListeners();
  }

  Future<void> _saveState() async {
    await _storage?.writeAll({
      'stars': _stars,
      'coins': _coins,
      'completedLessons': _completedLessons.toList(),
      'earnedBadges': _earnedBadges.toList(),
    });
  }

  Future<void> addStars(int count) async {
    _stars += count;
    notifyListeners();
    await _saveState();
  }

  Future<void> addCoins(int count) async {
    _coins += count;
    notifyListeners();
    await _saveState();
  }

  Future<void> completeLesson(String lessonId) async {
    _completedLessons.add(lessonId);
    notifyListeners();
    await _saveState();
  }

  bool isLessonCompleted(String lessonId) {
    return _completedLessons.contains(lessonId);
  }

  Future<void> earnBadge(String badgeId) async {
    _earnedBadges.add(badgeId);
    notifyListeners();
    await _saveState();
  }

  bool hasBadge(String badgeId) {
    return _earnedBadges.contains(badgeId);
  }

  Future<void> resetProgress() async {
    _stars = 0;
    _coins = 0;
    _completedLessons.clear();
    _earnedBadges.clear();
    notifyListeners();
    await _saveState();
  }

  void checkAndEarnBadges(List<RewardModel> rewards) {
    for (final reward in rewards) {
      if (_earnedBadges.contains(reward.id)) continue;
      if (reward.id == 'star_collector' && _stars >= reward.stars) {
        _earnedBadges.add(reward.id);
      } else if (reward.id == 'coin_hoarder' && _coins >= 100) {
        _earnedBadges.add(reward.id);
      } else if (reward.id == 'first_lesson' && _completedLessons.isNotEmpty) {
        _earnedBadges.add(reward.id);
      }
    }
    notifyListeners();
  }
}
