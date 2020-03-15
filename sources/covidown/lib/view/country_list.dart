//
import 'dart:convert';
//
import 'package:flutter/material.dart';
//
import 'package:covidown/model/country.dart';

class CountryListState extends State<CountryList> {
  final _suggestions = <String>[];
  final _saved = Set<Country>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Covidown'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildCovidown(context),
    );
  }
  Widget _buildCovidown(BuildContext context) {
    return FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString(
            'assets/datasets/countries.csv').asStream().transform(new LineSplitter()).toList(),
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.data == null) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset('assets/images/items/poke-ball.png'),
                ],
              )
              ],
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemBuilder: /*1*/ (context, i) {
              if (i.isOdd) {
                return Divider(); /*2*/
              }
              final index = i ~/ 2; /*3*/
              if (index >= _suggestions.length) {
                _suggestions.addAll(snapshot.data.skip(index + 1).take(10));
              }
              return _buildRow(_suggestions[index]);
            },
          );
        });
  }
  Widget _buildRow(String line) {
    final data = line.split(',');
    // TO REDO
    final country = Country(data[0], data[3]);
    final number = data[0];
    final name = data[1];
    final alreadySaved = _saved.contains(country);
    return ListTile(
      leading: Text(
        country.getEmoji()
      ),
      title: Text(
        name,
        style: _biggerFont,
      ),
      trailing: Icon (
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(country);
          } else {
            _saved.add(country);
          }
        });
      },
    );
  }
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
                (Country country) {
              return ListTile(
                title: Text(
                  country.name,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();
          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}

class CountryList extends StatefulWidget {
  @override
  CountryListState createState() => CountryListState();
}