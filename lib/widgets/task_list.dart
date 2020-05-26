import 'package:flutter/material.dart';
import 'package:foodlove/widgets/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:foodlove/models/task_data.dart';

class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final task = taskData.tasks[index];
            return TaskTile(
              taskTitle: task.name,
              quantity: task.quantity,
              longPressCallback: () {
                taskData.deleteTask(task.objectId,task);
              },
            );
          },
          itemCount: taskData.taskCount,
        );
      },
    );
  }
}
