import 'package:flutter/material.dart';
import 'file:///C:/Users/mandy/Desktop/practice/food_love/lib/widgets/recipe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodlove/constants/constants.dart';
import 'package:foodlove/models/recipe_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class PrivateRecipeScreen extends StatefulWidget {
  static const id = 'private_recipe_screen';
  final RecipeItem recipeItem;
  PrivateRecipeScreen({this.recipeItem});
  @override
  _PrivateRecipeScreenState createState() => _PrivateRecipeScreenState();
}

class _PrivateRecipeScreenState extends State<PrivateRecipeScreen> {
  bool privacy = true;
  void togglePrivacy(){
    privacy = !privacy;
  }
  Future<void> updatePrivacy()async{
    Firestore.instance
        .collection('recipes')
        .document(widget.recipeItem.id)
        .updateData({
      'private' : privacy,
    });}
  List<Object> response = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: FaIcon(FontAwesomeIcons.upload),onPressed: ()async{togglePrivacy();await updatePrivacy();  showGeneralDialog(
              barrierColor: Colors.black.withOpacity(0.5),
              transitionBuilder: (context, a1, a2, widget) {
                return Transform.scale(
                  scale: a1.value,
                  child: Opacity(
                    opacity: a1.value,
                    child: AlertDialog(
                      shape: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(16.0)),
                      title: Text(
                        privacy == true ? 'Private' : 'Public',
                        style: TextStyle(color: Colors.red),
                      ),
                      content: TyperAnimatedTextKit(
                          speed: Duration(milliseconds: 100),
                          onTap: () {
                            print("Tap Event");
                          },
                          text: [
                            "You have changed the privacy status of your recipe.","Press again to toggle the status."
                          ],
                          textStyle: TextStyle(
                            color: kOrange,
                            fontSize: 18.0,
                            fontFamily: 'Pacifico',
                          ),
                          textAlign: TextAlign.start,
                          alignment: AlignmentDirectional
                              .topStart // or Alignment.topLeft
                      ),
                    ),
                  ),
                );
              },
              transitionDuration: Duration(milliseconds: 200),
              barrierDismissible: true,
              barrierLabel: '',
              context: context,
              pageBuilder: (context, animation1, animation2) {
                return;
              });},color: Colors.white,),
        ],
        title: Text('Private Recipes',style: kHeading,),
      ),
      body: Recipe(name: widget.recipeItem.name,imageURL: widget.recipeItem.imageURL,id: widget.recipeItem.id,instructions: widget.recipeItem.instructions,email: widget.recipeItem.email,items: widget.recipeItem.items,quantity: widget.recipeItem.quantity,cuisine: widget.recipeItem.cuisine,),
    );
  }
}
