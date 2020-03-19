//
import 'package:latlong/latlong.dart';
//
import 'package:covidown/model/abstract_entity.dart';
import 'package:covidown/model/entities/country.dart';

class Report extends AbstractEntity {

  final int number;
  final Country country;
  final int confirmed;
  final int deaths;
  final int recovered;
  final LatLng coordinates;
  final String date;
  final String version;
  final int timestamp;


  Report({
    this.number,
    this.country,
    this.confirmed,
    this.deaths,
    this.recovered,
    this.coordinates,
    this.date,
    this.version,
    this.timestamp
  });

  int getIdentifier() {
    return number;
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'country': country == null ? null : country.toMap(),
      'confirmed': confirmed,
      'deaths': deaths,
      'recovered': recovered,
      'latitude': coordinates == null ? null : coordinates.latitude,
      'longitude': coordinates == null ? null : coordinates.longitude,
      'date': date,
      'version': version,
      'timestamp': timestamp
    };
  }

}