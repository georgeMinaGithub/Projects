

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:todo_app_flutter/shared/component/component.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../shared/app_cubit/cubit.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    var scaffoldKey = GlobalKey<ScaffoldState>();
    var formKey = GlobalKey<FormState>();
    var titleController = TextEditingController();
    var timeController = TextEditingController();
    var dateController = TextEditingController();


    return  BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(

        listener: (context, state) {
          if(state is AppInsertDatabaseState)
          {
            Navigator.pop(context);
          }
        },

        builder: (context, state) {

          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
              key: scaffoldKey,

          // ............................   App Bar ............................
              appBar: AppBar(
                title:  Center(
                  child: Text(
                    cubit.label[cubit.currentIndex],
                  ),
                ),

                actions:  [
                  IconButton(
                    onPressed: ()
                    {
                      ModeCubit.get(context).changeAppMode();
                    },
                    icon:   const  Icon(Icons.light_mode_outlined),
                  ),

                ],
                centerTitle: true,
                // backgroundColor: Colors.redAccent,
                leadingWidth: 70,
                toolbarHeight: 50,

              ),

          //............................... FloatingActionButton  ..............
              floatingActionButton: FloatingActionButton(
                backgroundColor:  Colors.redAccent,
                onPressed: () async
                {
                  if(cubit.isBottomSheetShown)
                  {
                    if(formKey.currentState!.validate())
                    {
                      cubit.insertToDatabase(
                          date: dateController.text,
                          time: timeController.text,
                          title: titleController.text
                      );
                    }
                  }
                  else
                  {
                    scaffoldKey.currentState?.showBottomSheet((context) =>
                        Container(
                          color:  ModeCubit.get(context).backgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultTextFormField(
                                      controller: titleController,
                                      type: TextInputType.text ,
                                      label: 'Enter Title',
                                      prefix: Icons.title,
                                      validator: (String? value)
                                      {
                                        if(value!.isEmpty)
                                        {
                                          return 'Title must be equal null';
                                        }
                                        return null;
                                      }
                                  ),

                                  const SizedBox(height: 15,),

                                  defaultTextFormField
                                    (
                                      controller: timeController,
                                      type: TextInputType.datetime ,
                                      label: 'Enter Time',
                                      prefix: Icons.watch_later_outlined,
                                      validator: (String? value)
                                      {
                                        if(value!.isEmpty)
                                        {
                                          return 'Time must be equal null';
                                        }
                                        return null;
                                      },
                                      onTap: ()
                                      {
                                        showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now()
                                        ).then((value)
                                        {
                                          timeController.text = value!.format(context).toString() ;
                                        }
                                        );
                                      }
                                  ),

                                  const SizedBox(height: 15,),

                                  defaultTextFormField(
                                      controller: dateController,
                                      type: TextInputType.datetime ,
                                      label: 'Enter Date',
                                      prefix: Icons.calendar_today,
                                      validator: (String? value)
                                      {
                                        if(value!.isEmpty)
                                        {
                                          return 'Date must be equal null';
                                        }
                                        return null;
                                      },
                                      onTap: ()
                                      {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.parse('2023-12-31'),
                                        ).then((value)
                                        {
                                          dateController.text = DateFormat.yMMMd().format(value!);
                                        });
                                      }
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                    ).closed.then((value)
                    {
                      cubit.changeBottomSheet(
                          isShow: false,
                          icon: Icons.edit
                      );

                    }
                    );

                    cubit.changeBottomSheet(
                        isShow: true,
                        icon: Icons.add
                    );

                  }
                },
                child: Icon(cubit.fabIcon),
              ),

            // ......................   BottomNavigationBar .............................
              bottomNavigationBar: BottomNavigationBar(

                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (index)
                {
                  cubit.changeIndex(index);
                },

                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu),
                      label: 'Task',
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline),
                      label: 'Done'
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive),
                      label: 'Archived'
                  ),

                ],
              ),


              // .......................  body ConditionalBuilder ...................
              body:  ConditionalBuilder(
                builder: (context) => cubit.screens[cubit.currentIndex] ,
                condition: state is! AppGetDatabaseLoadingState,
                fallback: (context) => const Center(child: CircularProgressIndicator()),
              )


          );

        },

      ),

    );

  }


}
