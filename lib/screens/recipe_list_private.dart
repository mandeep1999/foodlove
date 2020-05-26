import 'package:flutter/material.dart';
import 'package:foodlove/constants/constants.dart';
import 'package:foodlove/screens/private_recipes_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodlove/models/recipe_item.dart';


class DiscoverScreen extends StatefulWidget {
  static const String id = 'discover_screen';
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;
final _auth = FirebaseAuth.instance;
void getCurrentUser()async{
  try{final user = await _auth.currentUser();
  if(user != null)
  {
    loggedInUser = user;
    print(loggedInUser);
  }}
  catch(e)
  {
    print(e);
  }

}
void messagesStream()async {
  await for(var snapshot in  _firestore.collection('messages').snapshots()){
    for( var message in snapshot.documents){
      print(message.data);
    }
  }
}
class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipes',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28.0,color: Colors.white),),elevation: 0,),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              color: kOrangeAccent,
              padding: EdgeInsets.only(top:20.0),
              child: Container(
                padding: EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(70.0),bottomRight: Radius.circular(75.0)),
                  color: Colors.white
                ),
                child: MessageStream(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('recipes').snapshots(),
      builder: (context, snapshot){
        List<CardBox> messageBubbles = [];
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: kOrangeAccent,
            ),
          );
        }
        final messages = snapshot.data.documents;
        for(var message in messages){
          final email = message.data['email'];
          final name = message.data['name'];
          final imageURL = message.data['imageURL'];
          final instructions = message.data['instructions'];
          final items = message.data['items'];
          final quantity = message.data['quantity'];
          final cuisine = message.data['cuisine'];
          final id = message.documentID;
          final currentUser = loggedInUser.email;
          if(currentUser == email){
            final messageBubble = CardBox(email: email,imageURL: imageURL,title: name,id: id,instructions: instructions,items: items,quantity: quantity,cuisine: cuisine,);
            messageBubbles.add(messageBubble);
          }
        }
        return ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles.isEmpty ? <Widget>[
              Center(child: Text('Nothing here yet.',style: TextStyle(fontSize: 20.0,color: kOrangeAccent,fontWeight: FontWeight.bold),)),
              SizedBox(height: 40.0,),
              Center(child: Image.asset('images/nothing_here_yet.png'),),
            ] : messageBubbles,
          );

      },
    );
  }
}

class CardBox extends StatelessWidget {
  final String id;
  final items;
  final quantity;
  final String imageURL;
  final String email;
  final String instructions;
  final cuisine;
  CardBox({this.title,this.id,this.instructions,this.email,this.imageURL,this.quantity,this.items,this.cuisine});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      child: FlatButton(
        onPressed: (){  Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PrivateRecipeScreen(
        recipeItem: RecipeItem(id: id,imageURL: imageURL,email: email,instructions: instructions,name: title,items:items,quantity:quantity,cuisine:cuisine),
      );
    }));},
        child: Card(
          elevation: 5.0,
          child: ListTile(
              leading: Icon(Icons.fastfood),
              title: Text(title,style: TextStyle(fontSize: 20.0,color: kBlack),),
              trailing: Icon(Icons.forward)
          ),
        ),
      ),
    );
  }
}



