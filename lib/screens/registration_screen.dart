import 'package:flutter/material.dart';
import 'package:foodlove/component/rounded_button.dart';
import 'package:foodlove/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodlove/screens/profile.dart';
import 'package:provider/provider.dart';
import 'package:foodlove/models/task_data.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:foodlove/screens/loading.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;
  String password;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  void toggleSpinner() {
    showSpinner = !showSpinner;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          backgroundColor: Colors.orangeAccent,
        ),
        inAsyncCall: showSpinner,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TyperAnimatedTextKit(
                    speed: Duration(milliseconds: 100),
                    onTap: () {
                      print("Tap Event");
                    },
                    text: [
                      "Register to FoodLove",
                    ],
                    textStyle: TextStyle(
                      color: kOrange,
                      fontSize: 30.0,
                      fontFamily: 'Pacifico',
                    ),
                    textAlign: TextAlign.start,
                    alignment:
                    AlignmentDirectional.topStart // or Alignment.topLeft
                ),
                Flexible(
                    child: Container(
                      child: Hero(
                          tag: 1,
                          child: CircleAvatar(
                            backgroundImage: AssetImage('images/logo.jpg'),
                            radius: 80.0,
                          )),
                    )),
                SizedBox(
                  height: 20.0,
                ),
                Column(
                  children: <Widget>[
                    TextField(
                      style: kBlackTextStyle,
                      onChanged: (value) {
                        email = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: const Icon(
                          Icons.email,
                          color: kOrangeAccent,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: kOrange,width: 5.0),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kOrangeAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      style: kBlackTextStyle,
                      onChanged: (value) {
                        password = value;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: kOrangeAccent,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: kOrange,width: 5.0),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kOrangeAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                      ),
                    ),
                  ],
                ),

                RoundedButton(
                  title: 'Register',
                  colour: kOrange,
                  onPressed: () async {
                    try {
                      setState(() {
                        toggleSpinner();
                      });
                      final newUser = await _auth.createUserWithEmailAndPassword(
                          email: email, password: password);
                      if(newUser!=null)
                      {
                        await Provider.of<TaskData>(context).getUser();
                        Navigator.pushNamed(context, ProfileScreen.id);
                      }
                      setState(() {
                        toggleSpinner();
                      });
                    }catch(e){
                      showGeneralDialog(
                          barrierColor: kBlack.withOpacity(0.5),
                          transitionBuilder: (context, a1, a2, widget) {
                            return Transform.scale(
                              scale: a1.value,
                              child: Opacity(
                                opacity: a1.value,
                                child: AlertDialog(
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0)),
                                  title: Text('Error!!',style: TextStyle(color: Colors.red),),
                                  content:  TyperAnimatedTextKit(
                                      speed: Duration(milliseconds: 100),
                                      onTap: () {
                                        print("Tap Event");
                                      },
                                      text: [
                                        "Please give unused Email ID and Password.","Make sure your password length is minimum 6 characters.",
                                      ],
                                      textStyle: TextStyle(
                                        color: kOrange,
                                        fontSize: 18.0,
                                        fontFamily: 'Pacifico',
                                      ),
                                      textAlign: TextAlign.start,
                                      alignment:
                                      AlignmentDirectional.topStart // or Alignment.topLeft
                                  ),
                                ),
                              ),
                            );
                          },
                          transitionDuration: Duration(milliseconds: 200),
                          barrierDismissible: true,
                          barrierLabel: '',
                          context: context,
                          pageBuilder: (context, animation1, animation2) {return ;});
                      setState(() {
                        toggleSpinner();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



