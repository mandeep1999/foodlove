import 'package:flutter/material.dart';
import 'package:foodlove/constants/constants.dart';
class Tile extends StatelessWidget {
  final String title;
  final Function returnValue;
  Tile({this.title,this.returnValue});
  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(20.0),
      decoration: kBoxDecoration,
      child: TextField(
        onChanged: (newValue){
          returnValue(newValue);
        },
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: title,
        ),
      ),
    );
  }
}
