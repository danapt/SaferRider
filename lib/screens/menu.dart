import 'package:flutter/material.dart';
import 'package:saferrider/screens/homescreen.dart';
import 'package:saferrider/screens/hazardscreen.dart';
import 'package:saferrider/screens/authscreen.dart';
import 'package:saferrider/screens/weatherscreen.dart';
import 'package:saferrider/utils/auth.dart';


class MenuWidget extends StatefulWidget {
  String title;
  MenuWidget(this.title);
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  @override
  Widget build(BuildContext context) {
    return  PopupMenuButton<int>(
      icon: Container(
        padding: EdgeInsets.only(
          left: 3, right: 3,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: Colors.white, width: 1)
        ),
        child: Icon(Icons.dehaze, color: Colors.white,size: 30,),
      ),
      padding: EdgeInsets.all(0),
      itemBuilder: (context) => [

        widget.title == "home"? PopupMenuItem(
            value: 0,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "HAZARD",
                textAlign: TextAlign.center,
                style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
              ),
            )
        ):
        PopupMenuItem(
            value: 0,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "HOME",
                textAlign: TextAlign.center,
                style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
              ),
            )
        ),

        widget.title == "weather" ? PopupMenuItem(
            value: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "HAZARD",
                textAlign: TextAlign.center,
                style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
              ),
            )
        ):
        PopupMenuItem(
            value: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "WEATHER",
                textAlign: TextAlign.center,
                style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
              ),
            )
        ),

        PopupMenuItem(
            value: 2,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "LOGOUT",
                textAlign: TextAlign.center,
                style:
                TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
              ),
            )
        ),
      ],
      onSelected: (value){
        if(value == 0){
          widget.title == "home"? _goHazard():_goHome();
        }
        if(value == 1){
          widget.title == "weather"?_goHazard():_goWheather();
        }
        if(value == 2){
          _logout();
        }
      },
      elevation: 0,
    );
  }

  _goWheather() {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>WeatherScreen()), (Route<dynamic> route) => false);
  }

  _goHazard(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HazardScreen()), (Route<dynamic> route) => false);
  }

  _goHome(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()), (Route<dynamic> route) => false);
  }

  _logout()async{
    await Auth.signOut();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AuthScreen()), (Route<dynamic> route) => false);
  }
}
