import 'package:flutter/material.dart';
import 'package:foodlove/component/rounded_button.dart';
import 'package:foodlove/constants/constants.dart';
import 'package:foodlove/models/task_data.dart';
import 'package:foodlove/screens/Home.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{
  File _image;
  String name;
  String _uploadedFileURL;
  bool showSpinner = false;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 20);
    setState(() {
      showSpinner = false;
      _image = image;
    });
  }

  Future uploadFile() async {
    if(_image != null ) {
      String email = Provider
          .of<TaskData>(context)
          .getEmail;
      print('upload');
      StorageReference storageReference =
      FirebaseStorage.instance.ref().child('pictures/profiles/$email');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
      print('File Uploaded');
      await storageReference.getDownloadURL().then((fileURL) {
        _uploadedFileURL = fileURL;
      });
    }}
  TextEditingController controller;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TextEditingController(text: Provider.of<TaskData>(context , listen: false).userName);
    name = Provider.of<TaskData>(context,listen: false).userName;
    _uploadedFileURL = Provider.of<TaskData>(context,listen: false).url;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed:  () async {
                    if(name != null && name != '') {
                      setState(() {
                        showSpinner = true;
                      });
                      await uploadFile();
                      await Provider.of<TaskData>(context)
                          .setProfile(name, _uploadedFileURL);
                      setState(() {
                        showSpinner = false;
                      });
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(Home.id, (route) => false);
                    }},
          ),
        ],
        elevation: 0,
        title: Text(
          'Profile',
          style: kHeading,
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          color: kOrangeAccent,
          child: Container(
            decoration: kCurvedBox,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TyperAnimatedTextKit(
                      speed: Duration(milliseconds: 100),
                      onTap: () {
                        print("Tap Event");
                      },
                      text: [
                        "Set up your profile",
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
                  Column(
                    children: <Widget>[
                      (_uploadedFileURL == null || _image != null) ?Card(
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(82.0)),
                        child: CircleAvatar(
                          backgroundColor: kOrangeAccent,
                          radius: 82.0,
                          child: CircleAvatar(
                            backgroundImage: (_image != null)
                                ? FileImage(_image)
                                : AssetImage('images/logo.jpg') ,
                            radius: 80.0,
                          ),
                        ),
                      ): Container(height: 0,),
                      (_uploadedFileURL !=null && _image == null) ? Card(
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(82.0)),
                        child: CircleAvatar(
                          backgroundColor: kOrangeAccent,
                          radius: 82.0,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(_uploadedFileURL) ,
                            radius: 80.0,
                          ),
                        ),
                      ): Container(height: 0,),
                      SizedBox(
                        height: 10.0,
                      ),
                      RoundedButton(
                        title: 'Choose Image',
                        colour: kBlack,
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          await getImage();
                        },
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30.0),
                    child: TextField(
                      controller: controller,
                      onChanged: (newValue) {
                        name = newValue;
                      },
                      textAlign: TextAlign.center,
                      style: kTextStyle,
                      decoration: InputDecoration.collapsed(hintText: 'Name'),
                    ),
                    decoration: kBoxDecoration,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
