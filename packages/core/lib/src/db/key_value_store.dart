import 'app_database.dart';

/// Non-secret key/value cache on top of Drift. Keys prefixed with `session.`
/// are wiped at logout; other keys (version gate cache) survive.
class KeyValueStore {
  KeyValueStore(this._db);

  final AppDatabase _db;

  Future<String?> read(String key) async {
    final row = await (_db.select(
      _db.keyValues,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> write(String key, String value) => _db
      .into(_db.keyValues)
      .insertOnConflictUpdate(
        KeyValuesCompanion.insert(key: key, value: value),
      );

  Future<void> remove(String key) =>
      (_db.delete(_db.keyValues)..where((t) => t.key.equals(key))).go();
}
