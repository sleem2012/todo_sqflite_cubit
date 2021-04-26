import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/moduels/archived_tasks.dart';
import 'package:todo_app/moduels/done_tasks.dart';
import 'package:todo_app/moduels/new_tasks.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  List<Text> appBarTitles = [
    Text("New Tasks"),
    Text("Done Tasks"),
    Text("Archived Tasks"),
  ];

  void changeIndex(int index){
    currentIndex=index;
    emit(AppChangeBottomNavBarState());

  }
}
