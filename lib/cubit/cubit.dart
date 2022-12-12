
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_flutter/cubit/states.dart';
import 'package:todo_app_flutter/module/todo_screen/done_task.dart';
import 'package:todo_app_flutter/module/todo_screen/new_task.dart';

import '../module/todo_screen/archived_task.dart';


class AppCubit extends Cubit<AppStates>
{

  AppCubit(): super(AppInitialState());

  // ................... AppCubit get(context) ..............................
  static AppCubit get(context) => BlocProvider.of(context);


  //...................  Lists To Add newTasks or doneTasks or archivedTasks ...
  late List<Map> newTasks = [];
  late List<Map> doneTasks = [];
  late List<Map> archivedTasks = [];

  // ...................  Database .............................................
  late Database database;

  // ................... void changeBottomSheet  ...............................
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheet(
      {
        required bool isShow ,
        required IconData icon
      })
  {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  // ................... List<String> label .................................
  List<String> label = [
    'New Task',
    'Done Task',
    'Archived Task'
  ];

  // ................... List<Widget> screens ..................................
  List<Widget> screens = [
    const NewTask(),
    const DoneTask(),
    const ArchivedTask(),
  ];

  // ................... void changeIndex ......................................
  int currentIndex = 0;
  void changeIndex(int index)
  {
    currentIndex = index;
    emit(AppChangeBottomNavBarSheet());
  }

  //...................  createDatabase ........................................
  void createDatabase()
  {
    openDatabase(
        'todo_app.db',
        version: 1,

        onCreate: (database, version)
        {
          if (kDebugMode) {
            print('Data Base Created');
          }
          database.execute(
              'create table tasks(id integer primary key , title text, date text,time text, status text ) '
          ).then((value)
          {
            if (kDebugMode) {
              print('Table Created');
            }
          }).catchError((error)
          {
            if (kDebugMode) {
              print(error.toString());
            }
          }
          );
        },
        onOpen: (database)
        {
          getDateFromDatabase(database);
          if (kDebugMode) {
            print('Data Base Opened');
          }
        }
    ).then((value)
    {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  // ................... insertToDatabase ....................................
  insertToDatabase(
      {
        required String title,
        required String date,
        required String time,
      }) async
  {
    database.transaction((txn)async
    {
      await txn.rawInsert
        (
          'insert into tasks (title , date , time, status) values ("$title", "$date", "$time", "new")'
      ).then((value)
      {
        if (kDebugMode) {
          print("$value Inserted Successfully");
        }
        emit(AppInsertDatabaseState());

        getDateFromDatabase(database);

      }).catchError((onError)
      {
        if (kDebugMode) {
          print("Error When Inserted New Record ${onError.toString()}");
        }
      });
      // return null;
    });
  }

  // ...................  getDateFromDatabase .................................
  void getDateFromDatabase(database)
  {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());
    database.rawQuery('select * from tasks').then((value)
    {
      value.forEach((element)
      {
        if(element['status'] == 'new') {
          newTasks.add(element);
        }
        else if(element['status'] == 'done') {
          doneTasks.add(element);
        }
        else {
          archivedTasks.add(element);
        }
      }
      );
      emit(AppGetDatabaseState());
    });

  }

  //...................  updateDate ............................................
  void  updateDate(
      {
        required String status,
        required int id,
      }) async
  {
    database.rawUpdate(
      'update tasks set status = ? where id = ?', [status, '$id'],
    ).then((value)
    {
      getDateFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  //................... deleteDate ............................................
  void  deleteDate(
      {
        required int id,
      }) async
  {
    database.rawUpdate(
      'delete from tasks where id = ?', [ '$id'],
    ).then((value)
    {
      getDateFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }


}
