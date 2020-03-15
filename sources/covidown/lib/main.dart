//
import 'package:flutter/material.dart';
//
import 'package:covidown/view/country_list.dart';

void main() => runApp(Covidown());

class Covidown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covidown',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: CountryList(),
    );
  }
}

