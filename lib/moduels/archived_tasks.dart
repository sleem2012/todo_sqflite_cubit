import 'package:flutter/material.dart';

class ArchivedTasks extends StatefulWidget {
  @override
  _ArchivedTasksState createState() => _ArchivedTasksState();
}

class _ArchivedTasksState extends State<ArchivedTasks> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text("Archived Tasks "),
      ),
    );
  }
}
