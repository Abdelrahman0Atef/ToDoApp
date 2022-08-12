import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:testplatforms/Screens/ArchivedScreen.dart';
import 'package:testplatforms/Screens/DoneScreen.dart';
import 'package:testplatforms/Screens/NewTasks.dart';
import 'States.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> Screens = [NewTasks(), DoneTasks(), ArchivedTasks(),];
  List<String> Titles = ['New Tasks', 'Done Tasks', 'ArchivedTasks',];
  Database database;
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivetasks = [];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNabBarState());
  }

  void createDataBase() async {
    database = await openDatabase('ToDo.db', version: 1, onCreate: (database, version) {
      database
          .execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT)')
          .then((value) {
        print('table created');
      }).catchError((error) {
        print('error when create table ${error.toString}');
      });
    }, onOpen: (database) {
      getFromDataBase(database);
    });
  }

  insertDataBase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    return await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, time, date, status) VALUES("$title", "$time", "$date", "new")')
          .then((value) {
        print('$value insert success');
        emit(AppInsertDatabaseState());
        getFromDataBase(database);
      }).catchError((error) {
        print('insert failed ${error.toString()}');
      });

      return null;
    });
  }

  void getFromDataBase(database) {
    newtasks = [];
    donetasks = [];
    archivetasks = [];

    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newtasks.add(element);
        else if (element['status'] == 'done')
          donetasks.add(element);
        else
          archivetasks.add(element);
      });
      emit(AppCreateDatabaseState());
    });
  }

  void updateDate({
    @required String status,
    @required int id,
  }) async {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      getFromDataBase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteDate({
    @required int id,
  }) async {
    database.rawUpdate(
      'DELETE FROM tasks WHERE id = ?',
      [id],
    ).then((value) {
      getFromDataBase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  var isBottomSheetShown = false;
  IconData fabicon = Icons.edit;

  void changeBottomSheetState({
    @required bool isShow,
    @required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabicon = icon;

    emit(AppChangeBottomSheetState());
  }
}
