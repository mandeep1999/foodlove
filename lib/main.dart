import 'package:flutter/material.dart';
import 'package:foodlove/screens/Home.dart';
import 'package:foodlove/screens/loading.dart';
import 'package:foodlove/screens/profile.dart';
import 'package:foodlove/screens/recipe_list_private.dart';
import 'package:foodlove/screens/ingredients_screen.dart';
import 'package:foodlove/screens/private_recipes_screen.dart';
import 'package:foodlove/screens/public_recipe_screen.dart';
import 'package:foodlove/screens/recipe_list_public.dart';
import 'package:foodlove/screens/recipe_screen.dart';
import 'package:foodlove/screens/registration_screen.dart';
import 'package:foodlove/screens/welcome_screen.dart';
import 'package:foodlove/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:foodlove/models/task_data.dart';
import 'package:foodlove/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'screens/public_recipe_screen.dart';
import 'package:foodlove/constants/constants.dart';

void main() => runApp(FoodLove());



class FoodLove extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return ChangeNotifierProvider(
      create: (context) => TaskData(),
      child: MaterialApp(

        theme: ThemeData().copyWith(
          primaryColor: kOrangeAccent,
          textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.black54),
          ),
        ),
        home: _getLandingPage(),
        routes: {
          WelcomeScreen.id : (context) => WelcomeScreen(),
          RegistrationScreen.id : (context) => RegistrationScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          Home.id : (context) => Home(),
          RecipeScreen.id: (context) => RecipeScreen(),
          PrivateRecipeScreen.id : (context) => PrivateRecipeScreen(),
          PublicRecipeScreen.id : (context) => PublicRecipeScreen(),
          IngredientsScreen.id : (context) => IngredientsScreen(),
          DiscoverScreen.id: (context) => DiscoverScreen(),
          ProfileScreen.id: (context) => ProfileScreen(),
          LoadingScreen.id: (context) =>LoadingScreen(),
          ChatScreen.id : (context) => ChatScreen(),
          PublicScreen.id : (context) => PublicScreen(),
        } ,
      ),
    );
  }
}

Widget _getLandingPage() {
  return StreamBuilder<FirebaseUser>(
    stream: FirebaseAuth.instance.onAuthStateChanged,
    builder: (BuildContext context, snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data.providerData.length == 1) { // logged in using email and password
          return snapshot.data.isEmailVerified
              ? LoadingScreen()
              : WelcomeScreen();
        } else { // logged in using other providers
          return LoadingScreen();
        }
      } else {
        return WelcomeScreen();
      }
    },
  );
}