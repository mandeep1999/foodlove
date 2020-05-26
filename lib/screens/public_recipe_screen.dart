import 'package:flutter/material.dart';
import 'package:foodlove/constants/constants.dart';
import 'package:foodlove/widgets/recipe.dart';
import 'package:foodlove/models/recipe_item.dart';

class PublicRecipeScreen extends StatefulWidget {
  static const id = 'public_recipe_screen';
  final RecipeItem recipeItem;
  PublicRecipeScreen({this.recipeItem});
  @override
  _PublicRecipeScreenState createState() => _PublicRecipeScreenState();
}

class _PublicRecipeScreenState extends State<PublicRecipeScreen> {
  List<Object> response = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Public Recipes',style: kHeading,),
      ),
      body: Recipe(name: widget.recipeItem.name,imageURL: widget.recipeItem.imageURL,id: widget.recipeItem.id,instructions: widget.recipeItem.instructions,email: widget.recipeItem.email,items: widget.recipeItem.items,quantity: widget.recipeItem.quantity,cuisine: widget.recipeItem.cuisine,),
    );
  }
}

