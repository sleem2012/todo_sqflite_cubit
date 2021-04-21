import 'package:flutter/material.dart';
import 'package:todo_app/layout/home_layout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      home:HomeLayout(),
    );
  }}
