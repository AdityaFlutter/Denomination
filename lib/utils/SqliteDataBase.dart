import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteDataBase {
  late Database _db;
  final int _databaseVersion = 1;

  Future<Database> getDataBase() async {
    _db = await _initDatabase();
    return _db;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), "denomination.db"),
      onCreate: (db, version) {
        db.execute(
            "CREATE TABLE IF NOT EXISTS HISTORY(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,denominationId TEXT,category TEXT,remark TEXT, dateTime TEXT, grandTotal TEXT)");
        },
      version: _databaseVersion,
    );
  }

}
