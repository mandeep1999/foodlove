import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodlove/models/task_data.dart';
import 'package:foodlove/screens/Home.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoadingScreen extends StatefulWidget {
  static const String id='loading_screen';
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {

    Provider.of<TaskData>(context,listen: false).getCurrentUser().then((_) => Provider.of<TaskData>(context,listen: false).getProfile().then((_) {Navigator.pushNamedAndRemoveUntil(context, Home.id, (route) => false);}));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   body: Center(child: TyperAnimatedTextKit(
       onTap: () {
         print("Tap Event");
       },
       text: [
         "FoodLove",
       ],
       textStyle: TextStyle(
         color: Colors.orangeAccent,
           fontSize: 50.0,
           fontFamily: "Pacifico"
       ),
       textAlign: TextAlign.start,
       alignment: AlignmentDirectional.topStart // or Alignment.topLeft
   ),),
    );
  }
}
