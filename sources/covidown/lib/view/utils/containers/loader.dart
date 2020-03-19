//
import 'package:flutter/material.dart';

class Loader {

  static Widget create() {
    return Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new SizedBox(
                child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Color.alphaBlend(
                            Color.fromRGBO(1, 144  , 176, 100.0),
                            Color.fromRGBO(0, 165, 203, 100.0)
                        )
                    )
                ),
                height: 200.0,
                width: 200.0,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new SizedBox(
                child: Image.asset(
                  'assets/images/icon/icon.png',
                  height: 100.0,
                  width: 100.0,
                ),
                height: 150.0,
                width: 150.0,
              )
            ],
          ),
        ],
      ),
    );
  }

}