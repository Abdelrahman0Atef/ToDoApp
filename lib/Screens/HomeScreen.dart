import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:testplatforms/Comp/Cubit.dart';
import 'package:testplatforms/Comp/States.dart';
import 'package:testplatforms/Comp/Comp.dart';

class HomeScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.Screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            appBar: AppBar(
              title: Text(cubit.Titles[cubit.currentIndex]),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState.validate()) {
                    cubit.insertDataBase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                  }
                } else {
                  scaffoldKey.currentState
                      .showBottomSheet(
                          (context) => Container(
                                padding: EdgeInsets.all(20.0),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      defaultFormField(
                                          controller: titleController,
                                          type: TextInputType.text,
                                          lable: 'Task Title',
                                          prefix: Icons.title,
                                          validate: (String value) {
                                            if (value.isEmpty) {
                                              return 'Title must not be empty';
                                            }
                                            return null;
                                          }),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      defaultFormField(
                                          readOnly: true,
                                          onTap: () {
                                            showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            ).then((value) {
                                              timeController.text =
                                                  value.format(context);
                                              print(value.format(context));
                                            });
                                          },
                                          controller: timeController,
                                          type: TextInputType.datetime,
                                          lable: 'Task Time',
                                          prefix: Icons.watch_later_outlined,
                                          validate: (String value) {
                                            if (value.isEmpty) {
                                              return 'Time must not be empty';
                                            }
                                            return null;
                                          }),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      defaultFormField(
                                          readOnly: true,
                                          onTap: () {
                                            showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime.parse(
                                                        '2021-06-03'))
                                                .then((value) {
                                              print(DateFormat.yMMMd()
                                                  .format(value));
                                              dateController.text =
                                                  DateFormat.yMMMd()
                                                      .format(value);
                                            });
                                          },
                                          controller: dateController,
                                          type: TextInputType.datetime,
                                          lable: 'Task Time',
                                          prefix: Icons.calendar_today,
                                          validate: (String value) {
                                            if (value.isEmpty) {
                                              return 'Date must not be empty';
                                            }
                                            return null;
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                          elevation: 20)
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabicon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline),
                    label: 'Done Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.arrow_circle_down),
                    label: 'Archived Tasks'),
              ],
            ),
          );
        },
      ),
    );
  }
}
