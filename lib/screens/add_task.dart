import 'package:flutter/material.dart';
import 'package:foodlove/component/rounded_button.dart';
import 'package:foodlove/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:foodlove/models/task_data.dart';
class AddTaskScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    String newTaskTitle;
    String newTaskTitleQ;
    TextEditingController textEditingController = new TextEditingController();
    TextEditingController textEditingControllerQ = new TextEditingController();

    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Add Item to list',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: kOrangeAccent,
              ),
            ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              controller: textEditingController,
              style: TextStyle(color: kBlack,fontSize: 20.0),
              onChanged: (newText) {
                newTaskTitle = newText;
              },
            ),
            SizedBox(height: 20.0,),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Quantity'
              ),
              controller: textEditingControllerQ,
              style: TextStyle(color: kBlack,fontSize: 20.0),
              onChanged: (newText) {
                newTaskTitleQ = newText;
              },
            ),
            SizedBox(height: 20.0,),
          RoundedButton(title: 'ADD',colour: kOrangeAccent,    onPressed: () {
            if(newTaskTitle !=null )
            Provider.of<TaskData>(context).addTask(newTaskTitle,newTaskTitleQ);
            Navigator.pop(context);
          },),
          ],
        ),
      ),
    );
  }
}
