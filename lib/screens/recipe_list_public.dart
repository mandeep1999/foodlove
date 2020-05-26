import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodlove/constants/constants.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodlove/models/recipe_item.dart';
import 'package:foodlove/screens/public_recipe_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodlove/models/task_data.dart';
import 'package:provider/provider.dart';

enum cuisines { Default, Indian, Chinese, French, Italian }

class PublicScreen extends StatefulWidget {
  static const String id = 'public_screen';
  @override
  _PublicScreenState createState() => _PublicScreenState();
}

String search = '';
bool filter = true;
String userSearch = '';
List<CardBox> messageBubbles = [];
List<UserBubble> userBubbles = [];
bool pro;
int user;
cuisines _selection;
String userEmail;
TextEditingController textEditingController = new TextEditingController();
final _firestore = Firestore.instance;
FirebaseUser loggedInUser;
final _auth = FirebaseAuth.instance;
void getCurrentUser() async {
  try {
    final user = await _auth.currentUser();
    if (user != null) {
      loggedInUser = user;
      print(loggedInUser);
    }
  } catch (e) {
    print(e);
  }
}

void messagesStream() async {
  await for (var snapshot in _firestore.collection('messages').snapshots()) {
    for (var message in snapshot.documents) {
      print(message.data);
    }
  }
}

class _PublicScreenState extends State<PublicScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pro = Provider.of<TaskData>(context, listen: false).pro;
    getCurrentUser();
    messageBubbles = [];
    userBubbles = [];
    search = '';
    filter = true;
    _selection = cuisines.Default;
    userSearch = '';
    userEmail = null;
    _selection = cuisines.Default;
    user = 1;
  }

  @override
  Widget build(BuildContext context) {
    void refresh() {
      setState(() {
        messageBubbles = [];
        print(userEmail);
      });
    }

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          pro == true
              ? ToggleSwitch(
                  initialLabelIndex: 1,
                  minWidth: 70.0,
                  activeBgColor: kOrange,
                  activeTextColor: Colors.white,
                  inactiveBgColor: kOrangeAccent,
                  inactiveTextColor: Colors.white,
                  labels: ['', ''],
                  icons: [FontAwesomeIcons.users, FontAwesomeIcons.pizzaSlice],
                  onToggle: (index) {
                    setState(() {
                      if (index == 1) {
                        userEmail = null;
                        userSearch = '';
                        filter = true;
                      }
                      if (index == 0) {
                        search = '';
                        filter = false;
                      }
                      print('switched to: $index');
                      messageBubbles = [];
                      userBubbles = [];
                      user = index;
                      textEditingController.clear();
                    });
                  })
              : Container(height: 0),
          (user == 1)
              ? PopupMenuButton<cuisines>(
                  elevation: 10.0,
                  onSelected: (cuisines result) {
                    _selection = result;
                    refresh();
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<cuisines>>[
                    const PopupMenuItem<cuisines>(
                        value: cuisines.Default,
                        child: PopItem(
                          text: 'Clear',
                        )),
                    const PopupMenuItem<cuisines>(
                        value: cuisines.Indian,
                        child: PopItem(
                          text: 'Indian',
                        )),
                    const PopupMenuItem<cuisines>(
                      value: cuisines.Chinese,
                      child: PopItem(
                        text: 'Chinese',
                      ),
                    ),
                    const PopupMenuItem<cuisines>(
                      value: cuisines.French,
                      child: PopItem(
                        text: 'French',
                      ),
                    ),
                    const PopupMenuItem<cuisines>(
                      value: cuisines.Italian,
                      child: PopItem(
                        text: 'Italian',
                      ),
                    ),
                  ],
                )
              : Container(
                  height: 0,
                ),
        ],
        title: Text(
          'Explore',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 28.0, color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Container(
              padding: EdgeInsets.only(
                  left: 40.0, right: 20.0, top: 10, bottom: 20.0),
              child: TextField(
                controller: textEditingController,
                onChanged: (newValue) {
                  setState(() {
                    messageBubbles = [];
                    userBubbles = [];
                    user == 0 ? userSearch = newValue : search = newValue;
                  });
                },
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(
                  hintText: user == 0 ? 'Search User' : 'Search Recipe',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                color: kOrangeAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: kOrangeAccent,
              child: Container(
                padding: EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(80.0)),
                    color: Colors.white),
                child:
                    user == 0 ? UserStream(refresh: refresh) : MessageStream(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void addBubble(
    email, imageURL, name, id, instructions, items, quantity, cuisine) {
  final messageBubble = CardBox(
    email: email,
    imageURL: imageURL,
    title: name,
    id: id,
    instructions: instructions,
    items: items,
    quantity: quantity,
    cuisine: cuisine,
  );
  messageBubbles.add(messageBubble);
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('recipes').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents;
        for (var message in messages) {
          final email = message.data['email'];
          String name = message.data['name'];
          final imageURL = message.data['imageURL'];
          final instructions = message.data['instructions'];
          final items = message.data['items'];
          final quantity = message.data['quantity'];
          final cuisine = message.data['cuisine'];
          final id = message.documentID;
          final private = message.data['private'];
          if (private == false) {
            bool cuisineBool = _selection != cuisines.Default ? true : false;
            bool emailBool = userEmail != null ? true : false;
            bool searchBool = search != '' ? true : false;
            if ((cuisineBool == true
                    ? (cuisine == _selection.toString().substring(9))
                    : true) &&
                (emailBool == true
                    ? userEmail.toLowerCase() == email.toString().toLowerCase()
                    : true) &&
                (searchBool == true
                    ? name.toLowerCase().startsWith(search.toLowerCase())
                    : true)) {
              addBubble(email, imageURL, name, id, instructions, items,
                  quantity, cuisine);
            }
          }
        }
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          children: messageBubbles.isEmpty
              ? <Widget>[
                  Center(
                      child: Text(
                    'Nothing here yet.',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: kOrangeAccent,
                        fontWeight: FontWeight.bold),
                  )),
                  SizedBox(
                    height: 40.0,
                  ),
                  Center(
                    child: Image.asset('images/nothing_here_yet.png'),
                  ),
                ]
              : messageBubbles,
        );
      },
    );
  }
}

class UserStream extends StatelessWidget {
  final Function refresh;
  UserStream({this.refresh});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('profiles').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        var users = snapshot.data.documents;
        for (var user in users) {
          final name = user.data['name'];
          final imageURL = user.data['url'];
          final email = user.data['email'];
          if (userSearch == '') {
            userBubbles.add(UserBubble(
              name: name.length == 0 ? 'Not available' : name,
              imageURL: imageURL,
              email: email,
              refresh: refresh,
            ));
          } else if (name.toLowerCase().startsWith(userSearch.toLowerCase())) {
            userBubbles.add(UserBubble(
              name: name.length == 0 ? 'Not available' : name,
              imageURL: imageURL,
              email: email,
              refresh: refresh,
            ));
          }
        }
        return ListView(
          children: userBubbles,
        );
      },
    );
  }
}

class UserBubble extends StatelessWidget {
  final Function refresh;
  final String name;
  final imageURL;
  final String email;
  UserBubble({this.refresh, this.name, this.email, this.imageURL});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        userEmail = email;
        user = 1;
        refresh();
      },
      child: Card(
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(37.0),
                ),
                child: CircleAvatar(
                  backgroundColor: kOrangeAccent,
                  radius: 37.0,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: imageURL == null
                        ? Text(
                            name[0].toUpperCase(),
                            style: TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                                color: kOrangeAccent),
                          )
                        : null,
                    radius: 35.0,
                    backgroundImage:
                        imageURL == null ? null : NetworkImage(imageURL),
                  ),
                ),
              ),
            ),
            Container(
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardBox extends StatelessWidget {
  final String id;
  final String imageURL;
  final items;
  final quantity;
  final String email;
  final String instructions;
  final String cuisine;
  CardBox(
      {this.title,
      this.cuisine,
      this.id,
      this.instructions,
      this.email,
      this.imageURL,
      this.items,
      this.quantity});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      child: FlatButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return PublicRecipeScreen(
              recipeItem: RecipeItem(
                  id: id,
                  imageURL: imageURL,
                  email: email,
                  instructions: instructions,
                  name: title,
                  items: items,
                  cuisine: cuisine,
                  quantity: quantity),
            );
          }));
        },
        child: Card(
          elevation: 5.0,
          child: ListTile(
              leading: Icon(Icons.fastfood),
              title: Text(
                title,
                style: TextStyle(fontSize: 20.0, color: kBlack),
              ),
              trailing: Icon(Icons.forward)),
        ),
      ),
    );
  }
}

class PopItem extends StatelessWidget {
  const PopItem({this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: kOrange, fontSize: 20.0, fontWeight: FontWeight.bold),
    );
  }
}
