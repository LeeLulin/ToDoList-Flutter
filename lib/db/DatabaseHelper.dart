import 'dart:async';

import 'package:Doit/bean/Todos.dart';
import 'package:Doit/bean/user.dart';
import 'package:data_plugin/bmob/type/bmob_date.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableTodo = 'todo';
  final String columnId = 'id';
  final String title = 'title';
  final String desc = 'desc';
  final String date = 'date';
  final String time = 'time';
  final String remindTime = 'remindTime';
  final String remindTimeNoDay = 'remindTimeNoDay';
  final String isAlerted = 'isAlerted';
  final String isRepeat = 'isRepeat';
  final String imgId = 'imgId';
  final String bmobDate = 'bmobDate';
  final String objectId = 'objectId';
//  final String user = 'user';

  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'data.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableTodo('
            '$columnId INTEGER PRIMARY KEY, '
            '$objectId TEXT, '
            '$title TEXT, '
            '$desc TEXT, '
            '$date TEXT, '
            '$time TEXT, '
            '$imgId INTEGER, '
            '$isAlerted INTEGER, '
            '$isRepeat INTEGER, '
            '$remindTime INTEGER, '
            '$remindTimeNoDay INTEGER)'
    );
  }

//  Future open() async {
//    String databasesPath = await getDatabasesPath();
//    String path = join(databasesPath, 'data.db');
//    db = await openDatabase(path, version: 1,
//        onCreate: (Database db, int version) async {
//          await db.execute(
//              'CREATE TABLE $tableTodo('
//                  '$columnId INTEGER PRIMARY KEY, '
//                  '$objectId TEXT, '
//                  '$title TEXT, '
//                  '$desc TEXT, '
//                  '$date TEXT, '
//                  '$time TEXT, '
//                  '$imgId INTEGER, '
//                  '$isRepeat INTEGER, '
//                  '$remindTime INTEGER, '
//                  '$remindTimeNoDay INTEGER)'
//          );
//        });
//  }

  Future<int> insertTodo(Todos todos) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableTodo, todos.toMap());

    return result;
  }

  Future<List> selectTodo({int limit, int offset}) async {
    var dbClient = await db;
    var result = await dbClient.query(
      tableTodo,
      columns: [columnId, objectId, title, desc, date, time],
      limit: limit,
      offset: offset,
    );
    List<Todos> todos = [];
    result.forEach((item) => todos.add(Todos.fromSql(item)));
    return todos;
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $tableTodo'));
  }

  Future<List> getAllTodo() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableTodo ");
    List<Todos> todos = [];
    result.forEach((i) => todos.add(Todos.fromSql(i)));
    if (todos.length > 0) {
      return todos;
    }

    return null;
  }

  Future<int> deleteTodo(String id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateTodo(Todos todos) async {
    var dbClient = await db;
    return await dbClient.update(tableTodo, todos.toJson(),
        where: "$columnId = ?", whereArgs: [todos.id]);
  }

  Future<int> clearTodo() async{
    var dbClient = await db;
    await dbClient.rawDelete("delete from $tableTodo");
//    await dbClient.rawUpdate("update sqlite_sequence set seq = 0 where name = $tableTodo ");
    return null;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}