import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String quantity;
  final String taskTitle;
  final Function longPressCallback;

  TaskTile(
      {this.quantity,
        this.taskTitle,
        this.longPressCallback});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: ListTile(
        onLongPress: longPressCallback,
        title: Text(
          taskTitle[0].toUpperCase() + taskTitle.substring(1),
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.black,
          fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          quantity == null ? 'N/A' : quantity,
          style: TextStyle(
            fontSize: 18.0,
              color: Colors.black87,),
        ),
      ),
    );
  }
}
