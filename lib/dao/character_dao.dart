import 'package:rick_morty_app/database/app_database.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/models/character_favorite.dart';
import 'package:sqflite/sqlite_api.dart';

class CharacterDao{
  insert(Character character) async{
    Database db = await AppDatabase().openDb();
    await db.insert(AppDatabase().tableName, character.toMap());
  }

  delete(Character character) async{
    Database db = await AppDatabase().openDb();
    await db.delete(AppDatabase().tableName, where: 'id = ?', whereArgs: [character.id]);
  }

  Future<bool> isFavorite(Character character) async{
    Database db = await AppDatabase().openDb();
    List maps = await db.query(AppDatabase().tableName, where: 'id = ?', whereArgs: [character.id]);
    return maps.isNotEmpty;
  }

  Future<List<CharacterFavorite>> fetchAll() async{
    Database db = await AppDatabase().openDb();
    List maps = await db.query(AppDatabase().tableName);
    return maps.map((map) => CharacterFavorite.fromMap(map)).toList();
  }
}