import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MemDart {
  static final MemDart instance = MemDart._internal();
  factory MemDart() => instance;
  MemDart._internal();

  bool _initialized = false;
  late Box _box;

  static const String _boxName = 'auryn_memory_box';

  Future<void> init() async {
    if (_initialized) return;

    try {
      await Hive.initFlutter();

      // Open box without encryption for offline-first simplicity
      // Data stays local on device only
      _box = await Hive.openBox(_boxName);

      _initialized = true;
      debugPrint('[MemDart] initialized.');
    } catch (e) {
      debugPrint('[MemDart] Initialization failed: $e');
      rethrow;
    }
  }

  Future<void> save(String key, dynamic value) async {
    _ensureInit();
    await _box.put(key, value);
  }

  Future<dynamic> read(String key) async {
    _ensureInit();
    return _box.get(key);
  }

  Future<void> delete(String key) async {
    _ensureInit();
    await _box.delete(key);
  }

  Future<Map<String, dynamic>> query(String prefix) async {
    _ensureInit();
    final Map<String, dynamic> results = {};

    for (final key in _box.keys) {
      if (key.toString().startsWith(prefix)) {
        results[key.toString()] = _box.get(key);
      }
    }

    return results;
  }

  void _ensureInit() {
    if (!_initialized) {
      throw Exception('MemDart not initialized. Call MemDart().init() first.');
    }
  }
}
