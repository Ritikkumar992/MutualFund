import 'package:hive_flutter/hive_flutter.dart';
import '../features/schemes/models/scheme_model.dart';

// For Local Hive Cache.
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static const String _boxName = 'schemes_box';

  // inserting schemes in hive.
  Future<void> insertSchemes(List<Scheme> schemes) async {
    final box = await Hive.openBox<Scheme>(_boxName);
    // Converting List<Scheme> to Map<int, Scheme> for fast bulk insertion.
    final Map<int, Scheme> schemesMap = {
      for (var scheme in schemes) scheme.schemeCode: scheme
    };
    await box.putAll(schemesMap);
  }

  // getting schemes from hive.
  Future<List<Scheme>> getAllSchemes() async {
    final box = await Hive.openBox<Scheme>(_boxName);
    return box.values.toList();
  }

  // check hive has schemes or not.
  Future<bool> hasSchemes() async {
    final box = await Hive.openBox<Scheme>(_boxName);
    return box.isNotEmpty;
  }

  // clearing schemes from hive.
  Future<void> clearSchemes() async {
    final box = await Hive.openBox<Scheme>(_boxName);
    await box.clear();
  }
}
