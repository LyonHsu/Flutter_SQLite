
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Dog.dart';

class LyonDataBase{
  Future<Database> database;
  Future<Database> init() async{
    database = openDatabase(
      join(await getDatabasesPath(), 'doggie_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
        );
      },
      version: 1,
    );
    return database;
  }

  Future<List<Dog>> dogs() async {

    final Database db = await database;


    final List<Map<String, dynamic>> maps = await db.query('dogs');

    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }

  Future<void> insertDog(Dog dog) async {

    final Database db = await database;

    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateDog(Dog dog) async {

    final db = await database;

    await db.update(
      'dogs',
      dog.toMap(),

      where: "id = ?",

      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(int id) async {

    final db = await database;


    await db.delete(
      'dogs',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}