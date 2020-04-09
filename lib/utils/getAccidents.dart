import 'package:firebase_database/firebase_database.dart';
import 'package:saferrider/global/global.dart';
import 'package:saferrider/models/accident.dart';
import 'dart:convert';

Future getAccidents() async{
  await FirebaseDatabase.instance.reference().once().then((res){
    List data = json.decode(json.encode(res.value));
    for(var item in data){
      Accident _accident = Accident.fromJson(item);
      accidentData.add(_accident);
    }
  }).then((e){
    print(e);
  });
}
