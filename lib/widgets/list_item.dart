import 'package:flutter/material.dart';
import 'package:foodlove/constants/constants.dart';
class ListItem extends StatelessWidget {
  final String id;
  final String value;
  ListItem({this.id,this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: kBoxDecoration,
      child: FlatButton(
        child: Text(
          value,
          style: TextStyle(
              fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.w500),
        ),
        onPressed: () {
          Navigator.pushNamed(context, id);
        },
      ),
    );
  }
}
