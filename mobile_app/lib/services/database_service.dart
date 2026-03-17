import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {

  static Database? _db;

  Future<Database> get database async {

    if (_db != null) return _db!;

    _db = await initDB();
    return _db!;
  }

  initDB() async {

    String path = join(await getDatabasesPath(), "phishing_logs.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {

        await db.execute('''
        CREATE TABLE logs(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          input TEXT,
          result TEXT,
          timestamp TEXT
        )
        ''');

      },
    );
  }

  insertLog(String input, String result) async {

    final db = await database;

    await db.insert("logs", {
      "input": input,
      "result": result,
      "timestamp": DateTime.now().toString()
    });
  }

  getLogs() async {

    final db = await database;

    return await db.query("logs", orderBy: "id DESC");
  }
}