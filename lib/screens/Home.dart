import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodlove/component/rounded_button.dart';
import 'package:foodlove/screens/add_task.dart';
import 'package:foodlove/screens/chat_screen.dart';
import 'dart:io';
import 'package:foodlove/screens/profile.dart';
import 'package:foodlove/screens/recipe_list_private.dart';
import 'package:foodlove/screens/recipe_screen.dart';
import 'package:foodlove/screens/welcome_screen.dart';
import 'package:foodlove/widgets/task_list.dart';
import 'package:foodlove/models/task_data.dart';
import 'package:provider/provider.dart';
import 'package:foodlove/screens/recipe_list_public.dart';
import 'package:foodlove/screens/about_screen.dart';
import 'package:foodlove/constants/constants.dart';

class Home extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  final _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging  _fcm = FirebaseMessaging();
  AnimationController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _saveDeviceToken();
    controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage : $message");
        final snackbar = SnackBar(
          content: Text(message['notification']['title']),
          action: SnackBarAction(
            label: 'Go',
            onPressed: () => null,
          ),
        );
        Scaffold.of(context).showSnackBar(snackbar);
      },
    );
  }
  _saveDeviceToken() async{
    String uid = Provider.of<TaskData>(context,listen: false).userEmail;
    String fcmToken = await _fcm.getToken();
    if(fcmToken!= null){
      var tokenRef = _db.collection('profiles').document(uid).collection('tokens').document(fcmToken);
      await tokenRef.setData({
        'token' : fcmToken,
        'createdAt' : FieldValue.serverTimestamp(),
        'platform'  :Platform.operatingSystem
      });
    }
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: kOrangeAccent,
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SingleChildScrollView(
                        child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: AddTaskScreen(),
                    )));
          }),
      appBar: AppBar(
          elevation: 0,
          actions: <Widget>[
           Provider.of<TaskData>(context).pro == true ?  Padding(
             padding: const EdgeInsets.all(18.0),
             child: Text('PRO',style: TextStyle(fontSize: 18.0)),
           ) : Container(height : 0),
          ],
          title: Text(
            ' Home',
            style: kHeading,
          )),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  color: kOrangeAccent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(80.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 18.0),
                  child: UserAccountsDrawerHeader(
                    accountName: Text(
                      Provider.of<TaskData>(context).userName == null
                          ? 'Not Available'
                          : Provider.of<TaskData>(context).userName,
                      style: TextStyle(fontSize: 20.0),
                    ),
                    accountEmail: Text(
                      Provider.of<TaskData>(context).loggedInUser.email,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage:
                          Provider.of<TaskData>(context).url != null
                              ? NetworkImage(Provider.of<TaskData>(context).url)
                              : AssetImage('images/logo.jpg'),
                      backgroundColor:
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? Colors.blue
                              : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Add Recipe",
                style: TextStyle(fontSize: 20.0, color: kOrangeAccent),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, RecipeScreen.id);
              },
            ),
            ListTile(
              title: Text(
                "Private Recipes",
                style: TextStyle(fontSize: 20.0, color: kOrangeAccent),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, DiscoverScreen.id);
              },
            ),
            ListTile(
              title: Text(
                "Explore",
                style: TextStyle(fontSize: 20.0, color: kOrangeAccent),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, PublicScreen.id);
              },
            ),
            ListTile(
              title: Text(
                "Group Chat",
                style: TextStyle(fontSize: 20.0, color: kOrangeAccent),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, ChatScreen.id);
              },
            ),
            ListTile(
              title: Text(
                "Profile",
                style: TextStyle(fontSize: 20.0, color: kOrangeAccent),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, ProfileScreen.id);
              },
            ),
            ListTile(
              title: Text(
                "About",
                style: TextStyle(fontSize: 20.0, color: kOrangeAccent),
              ),
              trailing: FaIcon(FontAwesomeIcons.infoCircle),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutScreen()));
              },
            ),
            ListTile(
              title: Text(
                "Log Out",
                style: TextStyle(fontSize: 20.0, color: kOrangeAccent),
              ),
              trailing: FaIcon(FontAwesomeIcons.signOutAlt),
              onTap: () {
                Provider.of<TaskData>(context).signOut();
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(WelcomeScreen.id, (route) => false);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                color: kOrangeAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80.0 * controller.value),
                ),
              ),
              width: double.infinity,
              padding: EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${Provider.of<TaskData>(context).taskCount} Items',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RoundedButton(
                        onPressed: () async {
                          await Provider.of<TaskData>(context).clearList();
                        },
                        title: 'Clear List',
                        colour: Colors.white,
                        textColor: kOrangeAccent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: kOrangeAccent,
              ),
              child: Container(
                padding: EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(80.0 * controller.value),
                  ),
                ),
                child: Provider.of<TaskData>(context).taskCount == 0
                    ? Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Nothing here yet, Click on add button to add items to list.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 20.0),
                            ),
                          ),
                          Image.asset(
                            'images/nothing_here_yet.png',
                            height: 380.0,
                          )
                        ],
                      )
                    : TasksList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
