import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;


class result extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Currency Detector",
          ),
        ),
        body: Stack(
            children: <Widget>[
              Text(globals.a!=null? globals.a : 'OUTPUT ',
                textAlign: TextAlign.center,
                //overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),

              // Text( globals.b ),

            ]

        )

    );

  }
}


