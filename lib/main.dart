import 'package:flutter/material.dart';
import 'dart:async';
import 'package:saferrider/screens/authscreen.dart';
import 'package:saferrider/screens/homescreen.dart';
import 'package:saferrider/models/weathersettings.dart';
import 'package:saferrider/utils/auth.dart';
import 'package:saferrider/utils/getAccidents.dart';
import 'package:saferrider/global/global.dart';
import 'package:saferrider/utils/manageWeather.dart';
import 'package:saferrider/utils/localNotificationHelper.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LocalNotificationHelper().initLocalNotification();
    return MaterialApp(
      title: 'Saferrider',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Splash(title: 'Saferrider'),
    );
  }
}


//splash screen--------------------------------------------------------------------------------------------
class Splash extends StatefulWidget {
  Splash({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash>  with SingleTickerProviderStateMixin{
  Animation animation, delayedAnimation, muchDelayAnimation, transfor,fadeAnimation;
  AnimationController animationController;


  @override
  void initState(){
    super.initState();
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: 0.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.fastOutSlowIn
    ));

    transfor = BorderRadiusTween(
        begin: BorderRadius.circular(125.0),
        end: BorderRadius.circular(0.0)).animate(
        CurvedAnimation(parent: animationController, curve: Curves.ease)
    );
    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animationController.forward();

    //splash loading timer function===============================================================
    new Timer(new Duration(seconds: 1), ()async{

      //get waether settings
      weatherSettings = await getWeatherSettingsLocal();
      if(weatherSettings == null)
        weatherSettings = new WeatherSettings(
          startTemp: -5,
          endTemp: 25,
          windSpeed: 4,
          startWindDirection: 20,
          endWindDirection: 40,
          heavyCloud: true,
          storm: true,
          heavyRain: true,
        );
      //get accidents data and save to variable+++++++++++++++++++++++++++++++++++++++++++++++++++++++
      await getAccidents();
      //check login info from local++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      Auth.getUserLocal().then((user){
        if(user != null){
          current_user = user;
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen()), (Route<dynamic> route) => false);
        }else{
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AuthScreen()), (Route<dynamic> route) => false);
        }
      });
    });
  }


  @override
  void dispose() {
    super.dispose();
  }


  //splash screen ==================================================================================
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
            body: new Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                    Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 1],
                ),
              ),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Flexible(
                    flex: 1,
                    child: new Center(
                      child: FadeTransition(
                          opacity: fadeAnimation,
                          child:
                          Container(
                            margin: EdgeInsets.only(bottom: 20.0),
                            padding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                            transform: Matrix4.rotationZ(-8 * pi / 180)
                              ..translate(-10.0),
                            // ..translate(-10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.deepOrange.shade900,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 8,
                                  color: Colors.black26,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: Text(
                              'Safer Rider',
                              style: TextStyle(
                                color: Theme.of(context).accentTextTheme.title.color,
                                fontSize: 50,
                                fontFamily: 'Anton',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
//splashscreen-------------------------------------------------------------------------------------------------------