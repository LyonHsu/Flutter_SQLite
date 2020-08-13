
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Dog.dart';

class LyonDataBase {
  Future<Database> database;
  // 初始化一个单订阅的Stream controller
  StreamController<String> streamController =new StreamController.broadcast();
  StreamSink<String> get _inAdd => streamController.sink;
  Stream<String> get outCounter => streamController.stream;
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

  void dispose(){
    streamController.close();
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
    db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    ).then((value) {
      getDogs();
    });
  }

  Future<void> updateDog(Dog dog) async {

    final db = await database;

    streamController.sink.add(dog.toMap().toString());
    await db.update(
      'dogs',
      dog.toMap(),

      where: "id = ?",

      whereArgs: [dog.id],
    ).then((value) {
      getDogs();
    });
  }

  Future<void> deleteDog(int id) async {
    final db = await database;
    await db.delete(
      'dogs',
      where: "id = ?",
      whereArgs: [id],
    ).then((value) {
      getDogs();
    });

  }

  getDogs()async{
    List<Dog> d =(await dogs()) ;
    streamController.sink.add(d.toString());
  }
}