//
import 'package:covidown/model/entities/country.dart';
import 'package:sqflite/sqflite.dart';
import 'package:latlong/latlong.dart';
//
import 'package:covidown/model/entities/report.dart';
import 'package:covidown/controller/abstract_dao.dart';

class ReportDAO extends AbstractDAO<Report> {

  ReportDAO({Database database}) : super(database: database);

  String getTable() {
    return 'reports';
  }

  String getDiscriminatorColumn() {
    return 'rowid';
  }

  Map<String, dynamic> toMap(Report entity) {
    Map map = entity.toMap();

    map['country'] = map['country']['name'];

    map.remove('number');

    return map;
  }

  Report toEntity(Map map) {
    return new Report(
      number: map[getDiscriminatorColumn()],
      country: new Country(
          name: map['country']
      ),
      confirmed: map['confirmed'],
      deaths: map['deaths'],
      recovered: map['recovered'],
      coordinates: map['latitude'] == null || map['longitude'] == null ? null : LatLng(map['latitude'], map['longitude']),
      date: map['date'],
      version: map['version'],
      timestamp: map['timestamp'],
    );
  }

  String createTable() {
    return 'CREATE TABLE ' + getTable() + ' (country TEXT, confirmed INTEGER, deaths INTEGER, recovered INTEGER, latitude REAL, longitude REAL, date TEXT, version TEXT, timestamp INTEGER)';
  }

  Future getVersion() async {
    final _version = await getDatabase().query(
      getTable(),
      columns: ['version', 'timestamp'],
      where: 'timestamp = (SELECT MAX(timestamp) FROM reports)',
      limit: 1,
    );

    if (_version.isEmpty) {
      return null;
    }

    return _version.single['version'];
  }

  Future getTotals({String version, Country country}) async {
    List arguments = [];

    String where = 'version =';

    if (version != null) {
      where = where + ' ?';

      arguments.add(version);
    } else {
      where = where + '  (SELECT version FROM reports WHERE timestamp = (SELECT MAX(timestamp) FROM reports LIMIT 1))';
    }

    if(country != null) {
      where = where + ' AND country = ?';

      arguments.add(country);
    }

    return toEntity(
        (await getDatabase().query(
            getTable(),
            columns: ['SUM(confirmed) AS confirmed', 'SUM(deaths) AS deaths', 'SUM(recovered) AS recovered', 'version'],
            where: where,
            whereArgs: arguments,
            groupBy: 'version'
        )).single
    );
  }

  Future getReports({String version, Country country}) async {
    List arguments = [];

    String where = 'version =';

    if (version != null) {
      where = where + ' ?';

      arguments.add(version);
    } else {
      where = where + ' (SELECT version FROM reports WHERE timestamp = (SELECT MAX(timestamp) FROM reports LIMIT 1))';
    }

    if(country != null) {
      where = where + ' AND country = ?';

      arguments.add(country.name);
    }

    return (await getDatabase().query(
        getTable(),
        where: where,
        whereArgs: arguments
    )).map((map) => toEntity(map)).toList();
  }

  Future getCountries({String version}) async {
    List arguments = [];

    String where = 'version =';

    if (version != null) {
      where = where + ' ?';

      arguments.add(version);
    } else {
      where = where + ' (SELECT version FROM reports WHERE timestamp = (SELECT MAX(timestamp) FROM reports LIMIT 1))';
    }

    return (await getDatabase().query(
        getTable(),
        columns: ['DISTINCT (country) AS country'],
        where: where,
        whereArgs: arguments,
        orderBy: 'country'
    )).map((map) => toEntity(map).country).toList();
  }

}