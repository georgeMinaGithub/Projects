import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_flutter/cubit/cubit.dart';
import 'package:todo_app_flutter/shared/component/component.dart';

import '../../cubit/states.dart';

class ArchivedTask extends StatelessWidget {
  const ArchivedTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit, AppStates>(

      listener: (context, state){},

      builder: (context, state){

        var tasks = AppCubit.get(context).archivedTasks;

        return tasksBuilder(
            tasks: tasks
        );

      },
    );
  }
}
