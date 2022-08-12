import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:testplatforms/Comp/Cubit.dart';

Widget defaultFormField({
  @required TextEditingController controller,
  @required TextInputType type,
  @required Function validate,
  @required String lable,
  @required IconData prefix,
  Function onChange,
  Function onSubmit,
  Function onTap,
  bool readOnly = false,
}) =>
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          5.0,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: TextFormField(
        readOnly: readOnly,
        controller: controller,
        keyboardType: type,
        onChanged: onChange,
        validator: validate,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: lable,
          prefixIcon: Icon(prefix),
          border: OutlineInputBorder(),
        ),
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text('${model['time']}'),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('${model['date']}',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
                icon: Icon(Icons.check_circle_outline),
                onPressed: () {
                  AppCubit.get(context)
                      .updateDate(status: 'done', id: model['id']);
                }),
            IconButton(
                icon: Icon(Icons.arrow_circle_down),
                onPressed: () {
                  AppCubit.get(context)
                      .updateDate(status: 'archive', id: model['id']);
                }),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteDate(id: model['id']);
      },
    );

Widget tasksBuilder({
  @required List<Map> tasks,
}) =>
    ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) => ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsetsDirectional.only(start: 20),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey[300],
                ),
              ),
          itemCount: tasks.length),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 100,
            ),
            Text(
              'No Tasks Yet, Please Add Some Tasks',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
    );
