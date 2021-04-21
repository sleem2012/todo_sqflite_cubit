import 'package:flutter/material.dart';
import 'package:todo_app/shared/components.dart';
import 'package:todo_app/shared/constans.dart';

class NewTasks extends StatefulWidget {
  @override
  _NewTasksState createState() => _NewTasksState();
}

class _NewTasksState extends State<NewTasks> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => buildTaskItem(tasks[index]),
      separatorBuilder: (context, index) =>
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 20.0
            ),
            child: Container(
            width: double.infinity, height: 1.0, color: Colors.grey[300]),
          ),
      itemCount: tasks.length,
    );
  }
}
