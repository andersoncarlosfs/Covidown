import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(Pokedex());

class Pokedex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomPokemons(),
    );
  }
}

class RandomPokemonsState extends State<RandomPokemons> {
  final _suggestions = <String>[];
  final _saved = Set<String>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokédex'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildPokedex(context),
    );
  }
  Widget _buildPokedex(BuildContext context) {
    return FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString(
            'assets/datasets/pokemons.csv').asStream().transform(new LineSplitter()).toList(),
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
  Widget _buildRow(String pokemon) {
    final data = pokemon.split(',');
    final number = data[0];
    final name = data[1];
    final alreadySaved = _saved.contains(pokemon);
    return ListTile(
      leading: new Image.asset(
        'assets/images/pokemons/${number}.png',
        color: alreadySaved ? null : Colors.black,
        colorBlendMode: BlendMode.modulate,
      ),
      title: Text(
        name,
        style: _biggerFont,
      ),
      trailing: new Image.asset(
        'assets/images/items/poke-ball.png',
        color: alreadySaved ? null : Colors.grey,
        colorBlendMode: BlendMode.modulate,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pokemon);
          } else {
            _saved.add(pokemon);
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
                (String pokemon) {
              return ListTile(
                title: Text(
                  pokemon,
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

class RandomPokemons extends StatefulWidget {
  @override
  RandomPokemonsState createState() => RandomPokemonsState();
}