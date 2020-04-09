import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
var platformChannelSpecifics;
class LocalNotificationHelper{
  initLocalNotification(){
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');

    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  }

  Future onSelectNotification(String payload){
    print(payload);
  }

  Future clearNotification()async{
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  //here we can request notification////
  Future setNotification(int id, String title, String body, int minutes)async{
//    print("scheduled notificaition");
//    DateTime scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 10));
//    print(scheduledNotificationDateTime.toString());

  if(minutes != 1){
    minutes += 60*7;//7 hour
  }
  //for test, let's set milliseconds instance of minutes
    Future.delayed(Duration(minutes: minutes), ()async{
      await flutterLocalNotificationsPlugin.show(
          id, title, body, platformChannelSpecifics,
          payload: 'item x');

    });
//        await flutterLocalNotificationsPlugin.schedule(
//        1,
//        'scheduled title',
//        'scheduled body',
//        scheduledNotificationDateTime,
//        platformChannelSpecifics,
//        payload: "id",
//        androidAllowWhileIdle: true);
//        print("========================done=========================");
//  }
}
}
