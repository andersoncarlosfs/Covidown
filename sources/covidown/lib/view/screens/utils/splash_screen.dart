//
import 'dart:async';
//
import 'package:flutter/material.dart';
//
import 'package:covidown/controller/database_manager.dart';
import 'package:covidown/view/utils/containers/loader.dart';
import 'package:covidown/view/screens/utils/total_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    DatabaseManager.upgrade().whenComplete(
            () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (BuildContext context) => TotalsScreen()
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Loader.create();
  }
}