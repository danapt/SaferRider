import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saferrider/models/harzard.dart';

Future<List<Hazard>> getHazard() async {
  List<Hazard> _hazards = [];
  var doc = await Firestore.instance.collection("harzard").getDocuments();
  doc.documents.forEach((doc){
    print(doc.data);
    _hazards.add(new Hazard.fromJson(doc.data));
  });
  return _hazards;
}

Future addHazard(Hazard _hazard)async{
  await Firestore.instance.collection("harzard").document(_hazard.uid).setData(_hazard.toJson());
}

Future deleteHazard(String uid)async{
  await Firestore.instance.collection("harzard").document(uid).delete();
}

Future updateHazard(Hazard _hazard)async{
  await Firestore.instance.collection("harzard").document(_hazard.uid).updateData(_hazard.toJson());
}