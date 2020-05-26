import 'package:flutter/material.dart';

final  BoxDecoration kBoxDecoration = BoxDecoration(
  border: Border.all(color: kBlack,width: 2.0),
  borderRadius: BorderRadius.circular(20.0),
);

final TextStyle kTextStyle = TextStyle(
  fontSize: 20.0,
  color: kOrange,
  fontWeight: FontWeight.bold
);

final TextStyle kBlackTextStyle = TextStyle(
  fontSize: 15.0,
  color: Colors.black,
);

final TextStyle kHeading = TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold);

final BoxDecoration kCurvedBox = BoxDecoration(
  borderRadius: BorderRadius.only(topLeft: Radius.circular(100.0),bottomRight: Radius.circular(100.0)),
  color: Colors.white,
);
const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: kOrangeAccent, width: 2.0),
  ),
);
const kSendButtonTextStyle = TextStyle(
  color: kOrangeAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);
const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);



const Color kOrangeAccent = Colors.orangeAccent;
const Color kOrange = Colors.orange;
const Color kBlack = Colors.black;


