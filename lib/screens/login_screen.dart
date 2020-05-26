import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodlove/component/rounded_button.dart';
import 'package:foodlove/constants/constants.dart';
import 'package:foodlove/screens/loading.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  TextEditingController textEditingControllerEmail =
      new TextEditingController();
  TextEditingController textEditingControllerPassword =
      new TextEditingController();
  void toggleSpinner() {
    showSpinner = !showSpinner;
  }

  @override
  void dispose() {
    print("dispose");
    textEditingControllerPassword.dispose();
    textEditingControllerEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          backgroundColor: kOrangeAccent,
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
                      "Login to FoodLove",
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
                      controller: textEditingControllerEmail,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: const Icon(
                          Icons.email,
                          color: kOrangeAccent,
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: kOrange, width: 5.0),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: kOrangeAccent, width: 2.0),
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
                      controller: textEditingControllerPassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: kOrangeAccent,
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: kOrange, width: 5.0),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: kOrangeAccent, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                      ),
                    ),
                  ],
                ),
                RoundedButton(
                  title: 'Login',
                  colour: kOrange,
                  onPressed: () async {
                    try {
                      setState(() {
                        toggleSpinner();
                      });
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (user != null) {
                        setState(() {
                          toggleSpinner();
                          textEditingControllerPassword.clear();
                          textEditingControllerEmail.clear();
                          email = '';
                          password = '';
                          Navigator.pushNamed(context, LoadingScreen.id);
                        });
                      }
                    } catch (e) {
                      showGeneralDialog(
                          barrierColor: kBlack.withOpacity(0.5),
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
                                    'Error!!',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content: TyperAnimatedTextKit(
                                      speed: Duration(milliseconds: 100),
                                      onTap: () {
                                        print("Tap Event");
                                      },
                                      text: [
                                        "Please give correct Email ID and Password.",
                                        "There might be a problem with your Internet.",
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
                          });
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
