//
import 'dart:async';
import 'dart:convert';
//
import 'package:covidown/model/entities/country.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
//
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:latlong/latlong.dart';
//
import 'package:covidown/model/entities/report.dart';
import 'package:covidown/controller/daos/country_dao.dart';
import 'package:covidown/controller/daos/report_dao.dart';

abstract class DatabaseManager {

  static final int _version = 1;
  static final String _file = 'database.db';

  static Future open() async {
    return await openDatabase(
        join(await getDatabasesPath(), _file),
        version: _version,
        onCreate: (Database database, int version) async {
          await database.transaction((transaction) async {
            final Batch batch = transaction.batch();

            batch.execute(new CountryDAO().createTable());
            batch.execute(new ReportDAO().createTable());

            await batch.commit();
          });
        }
    );
  }

  static upgrade() async {
    final Database _database = await DatabaseManager.open();

    final dao = new ReportDAO(database: _database);

    final currentVersion = await dao.getVersion();

    final candidateVersion = DatabaseManager.getCandidateVersion();

    if (currentVersion != candidateVersion) {
      await _persist(candidateVersion);
    }

    await _database.close();
  }

  static String getCandidateVersion({int days = 0}) {
    return DateFormat('MM-dd-yyyy').format(DateTime.now().subtract(Duration(days: days))) + '.csv';
  }

  static void _persist(String version) async {
    List<Report> entities = [];

    List<String> lines = await _retrieve(version);

    for (var line in lines) {

      List<String> values = _parse(line);

      values[5] = values[5].trim();
      values[6] = values[6].trim();

      Report report = new Report(
        country: new Country(
          code: null,
          name: values[3].replaceAll('"', ''),
        ),
        confirmed: int.parse(values[7]),
        deaths: int.parse(values[8]),
        recovered: int.parse(values[9]),
        coordinates: LatLng(
            double.parse(values[5] == '' ? '0' : values[5]),
            double.parse(values[6] == '' ? '0' : values[6])
        ),
        date: values[4],
        version: version,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      entities.add(report);

    }

    final Database database = await DatabaseManager.open();

    final dao = new ReportDAO(database: database);

    await dao.insertAll(entities);

    await database.close();

  }

  static Future _retrieve(String file, {int tries = 10, int current = 0, String latest = '04-08-2020.csv'}) async {
    final _response = await http.get('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/' + file);

    if (_response.statusCode == 200) {
      // Skipping headers
      return LineSplitter.split(_response.body).skip(1).toList(growable: false);
    }

    if (current < tries) {
      return await _retrieve(
          DatabaseManager.getCandidateVersion(days: current),
          current: current + 1
      );
    }

    if (latest != null) {
      return await _retrieve(
          DatabaseManager.getCandidateVersion(days: current),
          current: current,
          latest: null
      );
    }

    return null;
  }

  static List _parse(String line) {
    RegExp expression = new RegExp(r',(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)');

    int begin = 0;

    List<String> values = [];

    for (var match in expression.allMatches(line)) {
      int end = match.end;

      values.add(line.substring(begin, end - 1));

      begin = end;
    }

    values.add(line.substring(begin, line.length - 1));

    return values;
  }

}