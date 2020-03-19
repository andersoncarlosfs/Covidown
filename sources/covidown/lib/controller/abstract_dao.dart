//
import 'dart:async';
//
import 'package:sqflite/sqflite.dart';
//
import 'package:covidown/model/abstract_entity.dart';

abstract class AbstractDAO<T extends AbstractEntity> {

  Database database;

  AbstractDAO({this.database});

  String createTable();

  String getTable();

  String getDiscriminatorColumn();

  T toEntity(Map map);

  Database getDatabase() {
    return database;
  }

  Future insert(T entity) async {
    return await getDatabase().insert(getTable(), toMap(entity));
  }

  Future insertAll(List<T> entities) async {
    List list = [];

    await getDatabase().transaction((transaction) async {

      var batch = transaction.batch();

      entities.forEach((entity) => batch.insert(getTable(), toMap(entity)));

      await batch.commit();

    });
    print(list);
    return list;
  }

  Future find(identifier) async {
    List<Map> maps = await getDatabase().query(getTable());

    if (maps.length > 0) {
      return toEntity(maps.first);
    }

    return null;
  }

  Future list() async {
    List entities = [];

    for(final map in await getDatabase().query(getTable())){
      entities.add(toEntity(map));
    }

    return entities;
  }

  Future delete(identifier) async {
    return await getDatabase().delete(
        getTable(),
        where: '? = ?',
        whereArgs: [getDiscriminatorColumn(), identifier]
    );
  }

  Future update(T entity) async {
    return await getDatabase().update(
        getTable(),
        entity.toMap(),
        where: '? = ?',
        whereArgs: [getDiscriminatorColumn(), entity.getIdentifier()]
    );
  }

  Map<String, dynamic> toMap(T entity) {
    return entity.toMap();
  }

}