import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget{
@override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Safer Rider',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.deepOrange,
        fontFamily: 'Lato',
      ),
      home: Text("you are loged in!!!!"),
    );;
  }
}
