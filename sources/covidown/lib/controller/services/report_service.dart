//
import 'package:covidown/model/entities/country.dart';
import 'package:covidown/model/entities/report.dart';
import 'package:covidown/controller/database_manager.dart';
import 'package:covidown/controller/daos/report_dao.dart';
import 'package:covidown/controller/abstract_service.dart';

class ReportService extends AbstractSevice<ReportDAO, Report> {

  Future<ReportDAO> getDAO() async {
    return new ReportDAO(database: await DatabaseManager.open());
  }

  Future getTotals({String version, Country country}) async {
    return await (await getDAO()).getTotals(version: version, country: country);
  }

  Future getReports({String version, Country country}) async {
    return await (await getDAO()).getReports(version: version, country: country);
  }

  Future getCountries({String version}) async {
    return await (await getDAO()).getCountries(version: version);
  }

}