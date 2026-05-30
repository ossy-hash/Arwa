import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalStorage {
  static LocalStorage? _instance;
  late final File _file;

  LocalStorage._(Directory dir) : _file = File('${dir.path}/arwa_data.json');

  static Future<LocalStorage> getInstance() async {
    if (_instance != null) return _instance!;
    final dir = await getApplicationDocumentsDirectory();
    _instance = LocalStorage._(dir);
    return _instance!;
  }

  Future<Map<String, dynamic>> readAll() async {
    try {
      if (!await _file.exists()) return {};
      final content = await _file.readAsString();
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  Future<void> writeAll(Map<String, dynamic> data) async {
    await _file.writeAsString(jsonEncode(data));
  }
}
