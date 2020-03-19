//
import 'dart:math' as math;
//
import 'package:covidown/view/utils/containers/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong/latlong.dart';
//
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
//
import 'package:covidown/model/entities/country.dart';
import 'package:covidown/model/entities/report.dart';
import 'package:covidown/controller/services/report_service.dart';
import 'package:covidown/view/screens/utils/countries_screen.dart';
import 'package:covidown/view/utils/containers/loader.dart';

class TotalsScreenState extends State<TotalsScreen> {

  Country country;
  String version;

  TotalsScreenState({this.country, this.version});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        title: Text(country == null ? 'World' : country.name),
          actions: <Widget>[      // Add 3 lines from here...
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                 setState(() {
                   Settings.create(context);
                 });
                }
            ),
          ]
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: Text('Countries'),
          backgroundColor: Color.fromRGBO(Colors.blue.red, Colors.blue.green, Colors.blue.blue, 100.0),
          elevation: 0,
          onPressed: () {
            setState(() {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (BuildContext context) => CountriesScreen()
                  )
              );
            });
          }
      ),
      body: _buildTotalsS(context),
    );
  }

  Widget _buildTotalsS(BuildContext context) {
    return FutureBuilder(
        future: new ReportService().getReports(country: country, version: version),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData == false) {
            return Loader.create();
          }

          List<Report> reports = snapshot.data;

          int confirmed = 0;
          int deaths = 0;
          int recovered = 0;

          List<Marker> markers = [];

          for(var report in reports) {
            confirmed += report.confirmed;
            deaths += report.deaths;
            recovered += report.recovered;

            markers.add(
                Marker(
                  anchorPos: AnchorPos.align(AnchorAlign.center),
                  height: 25,
                  width: 25,
                  point: report.coordinates,
                  builder: (context) => Icon(Icons.warning, color: Colors.red),
                )
            );
          }

          return Column(
            children: [
              _buildCard('Confirmed', confirmed, Icons.sentiment_neutral, Colors.orange),
              _buildCard('Deaths', deaths, Icons.sentiment_dissatisfied, Colors.grey),
              _buildCard('Recovered', recovered, Icons.sentiment_satisfied, Colors.green),
              Expanded(
                  child: _buildMap(markers.toList(), country == null ? false : true)
              )
            ],
          );
        });
  }

  Widget _buildCard(String title, dynamic content, IconData icon, Color color) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(7),
        child: Stack(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Stack(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _buildIcon(icon, color),
                                _buildTitle(title)
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [_buildContent(content, color)],
                            )
                          ],
                        ))
                  ],
                ),
              )
            ]),
      ),
    );
  }

  Widget _buildIcon(IconData icon, Color color){
    return Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            icon,
            color: color,
            size: 50.0,
          ),
        )
    );
  }

  Widget _buildTitle(String title) {
    return
      Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child:Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                text: title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          )
      );
  }

  Widget _buildContent(dynamic content, Color color) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            RichText(
              textAlign: TextAlign.right,
              text: TextSpan(
                text: content.toString(),
                style: TextStyle(
                  color: color,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap(List<Marker> markers, bool zoom) {
    return
      Card(
          elevation: 5,
          child: FlutterMap(
            options: new MapOptions(
              center: zoom ? _center(markers) : LatLng(0, 0),
              zoom: zoom ? 3 : 0.5,
              plugins: [
                MarkerClusterPlugin(),
              ],
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
                tileProvider: NonCachingNetworkTileProvider(),
              ),
              new MarkerLayerOptions(
                markers: markers,
              ),
            ],
          )
      )
    ;
  }

  LatLng _center(List<Marker> markers) {
    if (markers.length < 0) {
      return LatLng(0, 0);
    }

    if (markers.length == 1) {
      return markers.first.point;
    }

    double x = 0;
    double y = 0;
    double z = 0;

    for(var maker in markers) {
      double latitude = maker.point.latitude * math.pi / 180;
      double longitude = maker.point.longitude * math.pi / 180;

      x += math.cos(latitude) * math.cos(longitude);
      y += math.cos(latitude) * math.sin(longitude);
      z += math.sin(latitude);
    }

    x = x / markers.length;
    y = y / markers.length;
    z = z / markers.length;

    double longitude = math.atan2(y, x);
    double squareRoot = math.sqrt(x * x + y * y);
    double latitude = math.atan2(z, squareRoot);

    return LatLng(latitude * 180 / math.pi, longitude * 180 / math.pi);
  }

}

class TotalsScreen extends StatefulWidget {

  Country country;
  String version;

  TotalsScreen({this.country, this.version});

  @override
  TotalsScreenState createState() => TotalsScreenState(country: this.country, version: this.version);

}