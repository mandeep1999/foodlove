import 'package:flutter/material.dart';
import 'package:foodlove/component/rounded_button.dart';
import 'package:foodlove/constants/constants.dart';
import 'package:foodlove/screens/login_screen.dart';
import 'package:foodlove/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatelessWidget {
static const String id = 'welcome_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TyperAnimatedTextKit(
              speed: Duration(milliseconds: 100),
                onTap: () {
                  print("Tap Event");
                },
                text: [
                  "Welcome to FoodLove",
                ],
                textStyle: TextStyle(
                  color: kOrange,
                    fontSize: 30.0,
                    fontFamily: 'Pacifico',
                ),
                textAlign: TextAlign.start,
                alignment: AlignmentDirectional.topStart // or Alignment.topLeft
            ),
            SizedBox(
              height: 70.0,
            ),
            Hero(tag: 1,child: CircleAvatar(backgroundImage: AssetImage('images/logo.jpg'),radius: 90.0,)),
            SizedBox(
              height: 90.0,
            ),
            RoundedButton(
              title: 'Log In',
              colour: kOrangeAccent,
              onPressed: () {
                   Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              title: 'Register',
              colour: kOrange,
              onPressed: () {
                   Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),

          ],
        ),
      ),
    );
  }
}
