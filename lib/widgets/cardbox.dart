import 'package:flutter/material.dart';
class CardBox extends StatelessWidget {
  final String id;
  CardBox({this.title,this.id});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      child: FlatButton(
        onPressed: (){Navigator.pushNamed(context, id);},
        child: Card(
          elevation: 5.0,
          child: ListTile(
              leading: Icon(Icons.fastfood),
              title: Text(title,style: TextStyle(fontSize: 20.0,color: Colors.black),),
              trailing: Icon(Icons.forward)
          ),
        ),
      ),
    );
  }
}
