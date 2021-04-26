import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/components.dart';
import 'package:todo_app/shared/constans.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool bottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AppCubit(),
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, AppStates state) {},
          builder: (BuildContext context, AppStates state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
                key: scaffoldKey,
                appBar: AppBar(
                  title: cubit.appBarTitles[cubit.currentIndex],
                ),
                body: ConditionalBuilder(
                  condition: true,
                  builder: (context) => cubit.screens[cubit.currentIndex],
                  fallback: (context) => Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  child: Icon(fabIcon),
                  onPressed: () {
                    if (bottomSheetShown) {
                      if (formKey.currentState.validate()) {
                        insertDatabase(
                          title: titleController.text,
                          time: timeController.text,
                          date: dateController.text,
                        ).then(
                          (value) {
                            Navigator.pop(context);
                            bottomSheetShown = false;
                          },
                        );
                      }
                    } else {
                      scaffoldKey.currentState
                          .showBottomSheet(
                            (context) => Container(
                              color: Colors.grey[100],
                              padding: EdgeInsets.all(20),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    defaultFormField(
                                        controller: titleController,
                                        type: TextInputType.text,
                                        validate: (String value) {
                                          if (value.isEmpty) {
                                            return 'title must not be empty';
                                          }
                                          return null;
                                        },
                                        label: ' Task Title',
                                        prefix: Icons.title,
                                        onTap: () {
                                          print("title taped");
                                        }),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    defaultFormField(
                                        controller: timeController,
                                        type: TextInputType.datetime,
                                        validate: (String value) {
                                          if (value.isEmpty) {
                                            return 'time must not be empty';
                                          }
                                          return null;
                                        },
                                        label: ' Task Time',
                                        prefix: Icons.watch_later_outlined,
                                        onTap: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) {
                                            timeController.text = value
                                                .format(context)
                                                .toString();
                                            print(value.format(context));
                                          });
                                        }),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    defaultFormField(
                                        controller: dateController,
                                        type: TextInputType.datetime,
                                        validate: (String value) {
                                          if (value.isEmpty) {
                                            return 'date must not be empty';
                                          }
                                          return null;
                                        },
                                        label: ' Task date',
                                        prefix: Icons.calendar_today,
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2021-06-03'),
                                          ).then((value) {
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value);
                                            print(DateFormat.yMMMd()
                                                .format(value));
                                          });
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .closed
                          .then((value) {
                        bottomSheetShown = false;
                      });

                      bottomSheetShown = true;
                    }
                  },
                ),
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: cubit.currentIndex,
                  onTap: (index) {
                    cubit.changeIndex(index);
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.menu),
                      label: 'Tasks',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline),
                      label: 'Done',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined),
                      label: 'Archived',
                    ),
                  ],
                ));
          },
        ));
  }

  Future<void> createDatabase() async {
    database = await openDatabase('todo.db', version: 1,
        onCreate: (database, version) {
      print('database created');
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
          .then((value) {
        print("table created");
      }).catchError((error) {
        print('error when creating table ${error.toString()}');
      });
    }, onOpen: (database) {
      getFromDatabase(database).then((value) {});
      print('database opened');
      print(tasks);
    });
  }

  Future insertDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    return await database.transaction((txn) {
      txn
          .rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
      )
          .then(
        (value) {
          print(" $value inserted successfully");
        },
      ).catchError(
        (error) {
          print("error when inserting ${error.toString()}");
        },
      );
      return null;
    });
  }

  Future<List<Map>> getFromDatabase(database) async {
    return await database.rawQuery('SELECT * FROM tasks');
  }
}
