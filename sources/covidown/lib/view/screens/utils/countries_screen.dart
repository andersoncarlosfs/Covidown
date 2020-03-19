//
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//
import 'package:covidown/model/entities/country.dart';
import 'package:covidown/controller/services/report_service.dart';
import 'package:covidown/view/utils/containers/loader.dart';
import 'package:covidown/view/screens/utils/total_screen.dart';

class CountriesScreenState extends State<CountriesScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        title: Text('Countries'),
      ),
      body: _buildCountries(context),
    );
  }

  Widget _buildCountries(BuildContext context) {
    return FutureBuilder(
        future: new ReportService().getCountries(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData == false) {
            return Loader.create();
          }

          final List<Country> countries = snapshot.data;

          final Iterable<ListTile> tiles = countries.map(
                (Country country) {
              return ListTile(
                  title: Text(
                    country.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (BuildContext context) => TotalsScreen(country: country)
                        )
                    );
                  }
              );
            },
          );

          final List<Widget> divided = ListTile
              .divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return ListView(children: divided);
        });
  }

}

class CountriesScreen extends StatefulWidget {
  @override
  CountriesScreenState createState() => CountriesScreenState();
}