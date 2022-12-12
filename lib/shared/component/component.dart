

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_flutter/cubit/cubit.dart';
import 'package:todo_app_flutter/shared/app_cubit/cubit.dart';

// ....................... default Text Form Filed .............................

Widget defaultTextFormField({
  FocusNode? focusNode,
  required TextEditingController controller,
  required TextInputType type,
  required String? Function(String?) validator,
  required String label,
  String? hint,
  onTap,
  onChanged,
  Function(String)? onFieldSubmitted,
  bool isPassword = false,
  bool isClickable = true,
  InputDecoration? decoration,
  IconData? suffix,
  IconData? prefix,
  Function? suffixPressed,
}) =>
    TextFormField(
      focusNode: FocusNode(),
      style: const TextStyle(),
      maxLines: 1,
      minLines: 1,
      controller: controller,
      validator: validator,
      enabled: isClickable,
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      obscureText: isPassword,
      keyboardType: type,
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefix,
          color: Colors.grey,
        ),
        suffixIcon: suffix != null
            ? IconButton(
          onPressed: () {
            suffixPressed!();
          },
          icon: Icon(
            suffix,
            color: Colors.grey,
          ),
        )
            : null,
        filled: true,
        isCollapsed: false,
        fillColor: Colors.deepOrange.withOpacity(0.2),
        hoverColor: Colors.red.withOpacity(0.2),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
          borderSide: BorderSide(
            color: Colors.green,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        labelText: label,
        labelStyle: const TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.deepOrangeAccent,
        ),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white),
        focusColor: Colors.white,
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
          borderSide: BorderSide(
            color: Colors.green,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
      ),
    );


// ............................  Widget build Task Item .......................
Widget buildTaskItem
    (Map model, context)
              =>    Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(

    padding: const EdgeInsets.all(20),

    child: Row(
      children:  [
        CircleAvatar(
          radius: 40,
          child:Text(
              '${model['time']}',
          ),
        ),

        const SizedBox(width: 20,),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children:  [
              Text(
                '${model['title']}',
              ),

              Text(
                '${model['date']}',
              ),
            ],
          ),

        ),

        IconButton(
            onPressed: ()
            {
              AppCubit.get(context).updateDate(
                  status: 'done',
                  id: model['id']
              );
            },
            icon: const Icon(Icons.check_box_outlined,)
        ),

        IconButton(
            onPressed: ()
            {
              AppCubit.get(context).updateDate(
                  status: 'archived',
                  id: model['id']
              );
            },
            icon: const Icon(Icons.archive,)
        ),
      ],

    ),

  ),
  onDismissed: (direction)
  {
    AppCubit.get(context).deleteDate(id: model['id']);
  },
);


// ............................... tasks Builder ...................................

Widget tasksBuilder
    ({required List<Map> tasks})
              =>     ConditionalBuilder(
                builder:(context) => ListView.separated(
                    itemBuilder: (context , index) => buildTaskItem(tasks[index], context),
                    separatorBuilder: (context , index) => Padding(
                      padding: const EdgeInsetsDirectional.only(start: 20),
                      child: Container(
                        width: double.infinity,
                        height: 2,
                        color: ModeCubit.get(context).backgroundColor,
                      ),
                    ),
                    itemCount: tasks.length
                ) ,
                fallback: (context) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      const Icon(
                        Icons.menu,
                        size: 100,
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        'No Data Yet , Please Add Some Data?',
                        style:  Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                condition: tasks.isNotEmpty ,

);

