import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodlove/component/rounded_button.dart';
import 'package:foodlove/component/tile.dart';
import 'package:foodlove/constants/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodlove/widgets/task_tile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:foodlove/models/task_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class RecipeScreen extends StatefulWidget {
  static const String id = 'recipe_screen';
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}
bool showSpinner = false;
String dropdownValue = 'Default';
class _RecipeScreenState extends State<RecipeScreen> {
  String id;
  @override
  void initState() {
    id = DateTime.now().toString();
    super.initState();
  }
  List<String> items = [];
  List <String> quantity = [];
  List<TaskTile> ingredientList = [];
  TextEditingController textEditingControllerItem = new TextEditingController();
  TextEditingController textEditingControllerQuantity = new TextEditingController();
  String item;
  String itemQuantity;
  File _image;
  String name;
  String instructions;
  String _uploadedFileURL;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    textEditingControllerQuantity.dispose();
    textEditingControllerItem.dispose();
    super.dispose();
  }


  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 20);
    _image = image;
    setState(() {
      showSpinner = false;

    });
  }

  Future uploadFile() async {
    print('upload');
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('pictures/recipes/$id');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    await storageReference.getDownloadURL().then((fileURL) {
      print(fileURL);
      _uploadedFileURL = fileURL;
    });
  }

  final _firestore = Firestore.instance;
  Future<void> addTask() async {
    await _firestore.collection("recipes")
        .document(id)
        .setData({
      'email': Provider.of<TaskData>(context).getEmail,
      'name': name,
      'instructions': instructions,
      'imageURL' : _uploadedFileURL,
      'private': true,
      'items' : items,
      'quantity' : quantity,
      'cuisine' : dropdownValue,
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        actions: <Widget>[
          IconButton(
            icon: FaIcon(FontAwesomeIcons.save),
            onPressed: () async{
              if(name == null || instructions == null || items.length == 0 || quantity.length == 0 || _image == null){
                print([name,_uploadedFileURL,instructions,items.length,quantity.length,dropdownValue]);
                showGeneralDialog(
                    barrierColor: Colors.black.withOpacity(0.5),
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
                                  "Please provide all the details.",
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
              }
              else{
              setState(() {
                showSpinner = true;
              });
              print('add');
              await uploadFile();
              await addTask();
              setState(() {
                showSpinner = false;
              });
                Navigator.pop(context);}}
          ),
        ],
        title: Text(
          'Add a recipe',
          style: kHeading,
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(15.0),
              padding: EdgeInsets.all(20.0),
              decoration: kBoxDecoration,
              child: TextField(
                onChanged: (newValue){
                  name = newValue;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Recipe Name',
                ),
              ),
            ),
            Container(
              decoration: kBoxDecoration,
              margin: EdgeInsets.all(15.0),
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                PopItem(text: 'Cuisine :  ',),
                DropMenu(),
              ],),
            ),
            Column(
              children: <Widget>[
                (_image != null )
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            elevation: 20.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(72.0)),
                            child: CircleAvatar(
                                radius: 72.0,
                                backgroundColor: kOrangeAccent,
                                child: CircleAvatar(
                                  backgroundColor: kOrangeAccent,
                                  backgroundImage: FileImage(_image),
                                  radius: 70.0,
                                ))),
                      )
                    : Container(
                        height: 0.0,
                      ),
                RoundedButton(
                  onPressed: () async {

                    setState(() {
                      showSpinner = true;
                    });
                    await getImage();
                  },
                  title: 'Upload Image',
                  colour: kBlack,
                ),
              ],
            ),
            Tile(
              title: 'Instructions..',
              returnValue: (newValue){
                instructions = newValue;
                print(instructions);
              },
            ),
            Container(
              decoration: kBoxDecoration,
              margin: EdgeInsets.all(15.0),
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Add Ingredients',
                    style: TextStyle(color: kOrange, fontSize: 20.0),
                  ),
                  RoundedButton(
                    title: 'Save Ingredient',
                    onPressed: () {
                         if(item != null && itemQuantity != null)
                           {
                             setState(() {
                               items.add(item);
                               quantity.add(itemQuantity);
                               ingredientList.add(TaskTile(taskTitle: item,quantity: itemQuantity,));
                               textEditingControllerItem.clear();
                               textEditingControllerQuantity.clear();
                             });
                           }
                    },
                    colour: kOrangeAccent,
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(15.0),
                        padding: EdgeInsets.all(20.0),
                        decoration: kBoxDecoration,
                        child: TextField(
                          onChanged: (newValue){
                            item = newValue;
                          },
                          controller: textEditingControllerItem,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(color: kBlack),
                          decoration: InputDecoration(
                            hintText: 'Ingredient name',
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(15.0),
                        padding: EdgeInsets.all(20.0),
                        decoration: kBoxDecoration,
                        child: TextField(
                          controller: textEditingControllerQuantity,
                          onChanged: (newValue){
                            itemQuantity = newValue;
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(color: kBlack),
                          decoration: InputDecoration(
                            hintText: 'Ingredient Quantity',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: RoundedButton(
                      title: 'Delete Last Ingredient',
                      onPressed: (){
                        if(items.length > 0 && quantity.length > 0){
                    setState(() {
                      items.removeLast();
                      quantity.removeLast();
                      ingredientList.removeLast();
                    });
                        }
                      },
                      colour: kBlack,
                    ),
                  ),
                ],
              ),
            ),
            ingredientList.length > 0 ? Center(child: Text('Ingredients',style: TextStyle(fontSize: 20.0,color: kOrangeAccent,fontWeight: FontWeight.w500),),): Container(height: 0,),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: ingredientList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PopItem extends StatelessWidget {
const  PopItem({this.text});
 final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text,textAlign: TextAlign.center,style: TextStyle(color: kOrange,fontSize: 20.0,fontWeight: FontWeight.bold),);
  }
}




class DropMenu extends StatefulWidget {
  DropMenu({Key key}) : super(key: key);

  @override
  _DropMenuState createState() => _DropMenuState();
}

class _DropMenuState extends State<DropMenu> {

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      elevation: 16,
      style: TextStyle(color: kOrange,fontSize: 20.0),
      underline: Container(
        height: 2,
        color: kOrangeAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Default','Indian', 'Chinese', 'French', 'Italian']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}