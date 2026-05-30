import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/alphabet_model.dart';
import '../models/vocabulary_model.dart';
import '../models/number_model.dart';
import '../models/shape_model.dart';
import '../models/reward_model.dart';
import '../models/game_model.dart';
import '../models/phonics_model.dart';
import '../models/sight_word_model.dart';
import '../models/arabic_alphabet_model.dart';
import '../models/arabic_vocabulary_model.dart';

class DataLoader {
  static Future<List<AlphabetModel>> loadAlphabet() async {
    final data = await rootBundle.loadString('assets/data/alphabet.json');
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((j) => AlphabetModel.fromJson(j)).toList();
  }

  static Future<VocabularyData> loadVocabulary() async {
    final data = await rootBundle.loadString('assets/data/vocabulary.json');
    final decoded = json.decode(data);
    return VocabularyData.fromJson(decoded);
  }

  static Future<List<NumberModel>> loadNumbers() async {
    final data = await rootBundle.loadString('assets/data/numbers.json');
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((j) => NumberModel.fromJson(j)).toList();
  }

  static Future<List<ShapeModel>> loadShapes() async {
    final data = await rootBundle.loadString('assets/data/shapes.json');
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((j) => ShapeModel.fromJson(j)).toList();
  }

  static Future<List<RewardModel>> loadRewards() async {
    final data = await rootBundle.loadString('assets/data/rewards.json');
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((j) => RewardModel.fromJson(j)).toList();
  }

  static Future<GameConfig> loadGames() async {
    final data = await rootBundle.loadString('assets/data/games.json');
    final decoded = json.decode(data);
    return GameConfig.fromJson(decoded);
  }

  static Future<List<PhonicsModel>> loadPhonics() async {
    final data = await rootBundle.loadString('assets/data/phonics.json');
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((j) => PhonicsModel.fromJson(j)).toList();
  }

  static Future<List<SightWordModel>> loadSightWords() async {
    final data = await rootBundle.loadString('assets/data/sight_words.json');
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((j) => SightWordModel.fromJson(j)).toList();
  }

  static Future<List<ArabicAlphabetModel>> loadArabicAlphabet() async {
    final data = await rootBundle.loadString('assets/data/arabic_alphabet.json');
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((j) => ArabicAlphabetModel.fromJson(j)).toList();
  }

  static Future<ArabicVocabularyData> loadArabicVocabulary() async {
    final data = await rootBundle.loadString('assets/data/arabic_vocabulary.json');
    final decoded = json.decode(data);
    return ArabicVocabularyData.fromJson(decoded);
  }
}
