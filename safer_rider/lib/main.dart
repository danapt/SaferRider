import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safer_rider/screens/map_screen.dart';
import './providers/auth.dart';
import 'package:safer_rider/screens/authentification_screen.dart';
import 'package:safer_rider/screens/map_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, _) => MaterialApp(
          title: 'Safer Rider',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
              home: AuthScreen(),
        ),
      ),
    );
  }
}
//authData.isAuthenticate ? MapScreen()