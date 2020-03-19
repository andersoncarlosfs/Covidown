//
import 'package:sqflite/sqflite.dart';
//
import 'package:covidown/model/entities/country.dart';
import 'package:covidown/controller/abstract_dao.dart';

class CountryDAO extends AbstractDAO<Country> {

  CountryDAO({Database database}) : super(database: database);

  String getTable() {
    return 'countries';
  }

  String getDiscriminatorColumn() {
    return 'code';
  }

  Country toEntity(Map map) {
    return Country(
      code: map['code'],
      name: map['name'],
    );
  }

  String createTable() {
    return 'CREATE TABLE ' + getTable() + ' (' + getDiscriminatorColumn() + ' TEXT PRIMARY KEY, name TEXT)';
  }

}