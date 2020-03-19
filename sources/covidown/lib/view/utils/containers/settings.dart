//
import 'package:flutter/material.dart';
//
import 'package:covidown/controller/database_manager.dart';
import 'package:covidown/view/screens/utils/total_screen.dart';

class Settings {

  static void create(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(         // Add 6 lines from here...
            appBar: AppBar(
              title: Text('Settings'),
            ),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:[
                  Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('Developer',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Text('MesTrevys'),
                          leading: Icon(
                            Icons.person,
                            color: Colors.blue,
                          ),
                        ),
                        Divider(),
                        ListTile(
                          title: Text('Datasource',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Text('Johns Hopkins University'),
                          leading: Icon(
                            Icons.school,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      DatabaseManager.upgrade().whenComplete(
                              () =>  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                  builder: (BuildContext context) => TotalsScreen()
                              ), (Route<dynamic> route) => false)
                      );
                    },
                    child: new Icon(
                      Icons.update,
                      color: Colors.blue,
                      size: 150.0,
                    ),
                    shape: new CircleBorder(),
                    elevation: 5.0,
                    fillColor: Colors.white,
                    padding: const EdgeInsets.all(100.0),
                  )
                ]
            ),
          );                       // ... to here.
        },
      ),
    );
  }
}