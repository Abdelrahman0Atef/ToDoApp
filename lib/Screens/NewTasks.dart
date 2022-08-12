import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testplatforms/Comp/Cubit.dart';
import 'package:testplatforms/Comp/States.dart';
import 'package:testplatforms/Comp/Comp.dart';

class NewTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {

          var tasks = AppCubit.get(context).newtasks;

          return tasksBuilder(tasks: tasks);
    });
  }
}
