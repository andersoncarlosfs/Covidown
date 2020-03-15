//
import 'dart:async';

//
import 'package:sqflite/sqflite.dart';


abstract class AbstractDataAccessObject {

  Database _database;

  void exist();

  Future open() async {
    _database = await openDatabase('', version: 1,
        onCreate: (Database db, int version) async {
          await _database.execute('''
            create table $tableTodo ( 
              $columnId integer primary key autoincrement, 
              $columnTitle text not null,
              $columnDone integer not null)
            ''');
        });
  }

  Future<Todo> insert(Todo todo) async {
    todo.id = await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  Future<Todo> getTodo(int id) async {
    List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnDone, columnTitle],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Todo.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Todo todo) async {
    return await db.update(tableTodo, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }

  Future close() async => db.close();

}