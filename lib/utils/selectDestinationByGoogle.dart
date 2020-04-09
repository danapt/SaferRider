import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:saferrider/global/global.dart';

Future<String> SelectDestinationByGoogle(BuildContext context)async{
  String destinationAddress;
  try{
    var p = await PlacesAutocomplete.show(
      context: context,
      apiKey: place_key,
      mode: Mode.overlay, // Mode.fullscreen
      language: "en",);
    print(p.description);
    destinationAddress = p.description;
  }catch(e){}

  return destinationAddress;
}