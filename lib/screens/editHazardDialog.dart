import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:saferrider/models/harzard.dart';
import 'package:saferrider/global/global.dart';
import 'package:saferrider/utils/manageHazards.dart';
import 'dart:convert';

class EditHazardDialog extends StatefulWidget {
  Hazard editingHazard;
  EditHazardDialog(this.editingHazard);
  @override
  _editHazardDialogState createState() => _editHazardDialogState();
}

class _editHazardDialogState extends State<EditHazardDialog> {
  bool _isAdding = false;
  List _hazardTypes = [
    {
      "type":"oil/diesel",
      "image":"assets/images/fuel.png"
    },
    {
      "type":"slippery roads",
      "image":"assets/images/slippery.png"
    },
    {
      "type":"flooded roads",
      "image":"assets/images/flood.png"
    },
    {
      "type":"police check point/speeding gun",
      "image":"assets/images/police.png"
    },
    {
      "type":"sand on the road",
      "image":"assets/images/sand.png"
    },
  ];
  Map _selectedHazardType;
  final _descriptionController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 50,
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: DropdownButton<Map>(
                value: _selectedHazardType,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                hint: Text("Select Hazard"),
                underline: Container(
                ),
                onChanged: (newValue) {
                  setState(() {
                    _selectedHazardType = newValue;
                  });
                },
                items: _hazardTypes
                    .map<DropdownMenuItem<Map>>((value) {
                  print(value);
                  return DropdownMenuItem<Map>(
                      value: value,
                      child: Row(
                        children: <Widget>[
                          Image.asset(value["image"]),
                          SizedBox(width: 20,),
                          Text(value['type']),
                        ],
                      )
                  );
                })
                    .toList(),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Description",
                  contentPadding: EdgeInsets.all(5),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1)
                  )
                ),
              ),
            ),
            Container(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                   color: Colors.red,
                    onPressed: (){
                     Navigator.pop(context);
                    },
                    child: Text("Cancel", style: TextStyle(color: Colors.white),),
                  ),
                  _isAdding?
                  CircularProgressIndicator():
                  FlatButton(
                    color: Colors.green,
                    onPressed: _editHazard,
                    child: Text("Add", style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _initData(){
    for(var item in _hazardTypes){
      if(item['type'] == widget.editingHazard.title){
        _selectedHazardType = item;
      }
    }

    _descriptionController.text = widget.editingHazard.description;
  }

  _editHazard()async{
    if(_selectedHazardType == null){
      Toast.show("Plese select hazard", context);
      return;
    }

    setState(() {
      _isAdding = true;
    });
    Hazard _hazard = new Hazard();
    _hazard.uid = widget.editingHazard.uid;
    _hazard.lat = widget.editingHazard.lat;
    _hazard.lng = widget.editingHazard.lng;
    _hazard.createAt = DateTime.now().toString();
    _hazard.description = _descriptionController.text;
    _hazard.image = _selectedHazardType['image'];
    _hazard.title = _selectedHazardType['type'];
    _hazard.userId = current_user.user_id;
    try{
      await updateHazard(_hazard);
      Navigator.pop(context, json.encode(_hazard.toJson()));
    }catch(e){

    }
    setState(() {
      _isAdding = false;
    });
  }
}
