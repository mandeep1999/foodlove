import 'package:flutter/material.dart';
import 'package:foodlove/component/rounded_button.dart';
import 'package:foodlove/constants/constants.dart';
import 'package:foodlove/screens/ingredients_screen.dart';

class Recipe extends StatelessWidget {
  final String name;
  final String instructions;
  final String imageURL;
  final String id;
  final String email;
  final String cuisine;
  final items;
  final quantity;
  Recipe({this.instructions,this.email,this.imageURL,this.id,this.name,this.items,this.quantity,this.cuisine});
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          decoration: kBoxDecoration,
          margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                name + ( cuisine!= 'Default' ? ' ($cuisine) ' : ''),
                style: kTextStyle,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(imageURL),
                  radius: 80.0,
                ),
              ),
              Text(
                'Instructions',
                style: kTextStyle,
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                 instructions,
                  style: TextStyle(fontSize: 18.0),
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              RoundedButton(
                title: 'View Ingredients',
                colour: Colors.black,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return IngredientsScreen(
                      items: items,quantity: quantity,
                    );
                  }));
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
