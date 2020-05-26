import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodlove/constants/constants.dart';
import 'package:foodlove/models/task_data.dart';
import 'package:foodlove/screens/about_developer.dart';
import 'package:provider/provider.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About',
          style: kHeading,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.supervisor_account),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Developer()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'About:',
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: kBlack),
            ),
            SizedBox(
              height: 50.0,
            ),
            Text(
              'Version 2.0',
              style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                  color: kBlack),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'It is a flutter app for food lovers, it acts a platform for '
              'cooks around the globle to manage and share their recipes. '
              'It helps the cook to easily manage their ingredients list. ',
              style: TextStyle(fontSize: 20.0, color: kBlack),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'You are using the ' +
                  (Provider.of<TaskData>(context).pro == true
                      ? 'PRO'
                      : 'FREE') +
                  ' version of the App.',
              style: TextStyle(fontSize: 20.0, color: kBlack),
            ),
          ],
        ),
      ),
    );
  }
}
