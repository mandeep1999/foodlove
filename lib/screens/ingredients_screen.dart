import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodlove/constants/constants.dart';
import 'package:foodlove/models/task_data.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:foodlove/screens/Home.dart';


class IngredientsScreen extends StatefulWidget {
  static final String id = 'ingredients_screen';
  final items;
  final quantity;
  IngredientsScreen({this.items,this.quantity});
  @override
  _IngredientsScreenState createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingredients',style: kHeading,),
        actions: <Widget>[
          IconButton(icon: FaIcon(FontAwesomeIcons.copy,color: Colors.white,),onPressed: ()async{
            setState(() {
              showSpinner = true;
            });
            for(int i = 0; i< widget.items.length; i++){
             await  Provider.of<TaskData>(context).copyTask(widget.items[i].toString(), widget.quantity[i].toString());
            }
            await Provider.of<TaskData>(context).copyStream();
            setState(() {
              showSpinner = false;
            });
            Navigator.pushNamedAndRemoveUntil(context, Home.id, (route) => false);
          },),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView.builder(itemCount: widget.items.length,itemBuilder: (context,index){
          return Card(
            elevation: 3.0,
            margin: EdgeInsets.all(10.0),
            child: ListTile(
              title: Text(
                widget.items[index][0].toUpperCase() + widget.items[index].substring(1),
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                widget.quantity[index] == null ? 'N/A' : widget.quantity[index],
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87,),
              ),
            ),
          );
        }),
      ),
    );
  }
}
