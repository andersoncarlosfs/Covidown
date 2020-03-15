//
import 'package:covidown/model/abstract_entity.dart';
import 'package:covidown/model/entities/country.dart';

class Report extends AbstractEntity { {
  final Country country;
  final int confirmed;
  final int deaths;
  final int recovered;
  final int timestamp;

  Report({this.country, this.confirmed, this.deaths, this.recovered, this.timestamp});

}