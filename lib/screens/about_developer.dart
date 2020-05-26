import"package:flutter/material.dart";
import 'package:foodlove/constants/constants.dart';
import 'package:foodlove/models/task_data.dart';
import 'package:foodlove/screens/loading.dart';
import 'package:provider/provider.dart';

int count = 0;
 class Developer extends StatelessWidget {

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title:Text('About Developer',style: kHeading,)),
       body: Padding(
         padding: const EdgeInsets.only(top: 20.0,left: 15.0,right: 15.0,bottom: 20.0),
         child: Column(
           children: <Widget>[
             Center(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: <Widget>[
                   Text('Mandeep Singh',style: TextStyle(fontSize: 25.0,color: kOrange),),
                   Padding(
                     padding: const EdgeInsets.all(55.0),
                     child: GestureDetector(onTap: ()async{
                       count++;
                       if(count == 5){
                         await Provider.of<TaskData>(context).setPro();
                         Navigator.pushNamedAndRemoveUntil(context, LoadingScreen.id, (route) => false);
                       }
                     },child: CircleAvatar(radius: 80.0,backgroundImage: AssetImage('images/developer.jpg'),)),
                   ),
                 ],
               ),
             ),
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 Text('Hi, I am Mandeep Singh. If you have downloaded my app you probably know me.',style: TextStyle(fontSize: 20.0,color: Colors.black),),
                 SizedBox(height: 30.0,),
                 Text('Thank you for downloading the app.',style: TextStyle(color: Colors.black,fontSize: 20.0),),

               ],
             ),
           ],
         ),
       )
     );
   }
 }
