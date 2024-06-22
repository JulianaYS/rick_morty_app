import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  final int version= 1;
  final String databaseName = 'rickmorty_app.db';
  final String tableName = 'character';
  Database? db;

  Future<Database> openDb() async {
    db ??= await openDatabase(
      join(await getDatabasesPath(), databaseName),
      version: version,
      onCreate: (db, version) {
        String query = 
          "CREATE TABLE $tableName(id INTEGER PRIMARY KEY, name TEXT, status TEXT, species TEXT, image TEXT)"; 
          db.execute(query);
      }
    );
    return db as Database;
  }
}