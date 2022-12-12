import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_flutter/cubit/cubit.dart';
import 'package:todo_app_flutter/shared/component/component.dart';

import '../../cubit/states.dart';


class NewTask extends StatelessWidget {
  const NewTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit, AppStates>(

      listener: (context, state){},

      builder: (context, state)
      {
        var tasks = AppCubit.get(context).newTasks;

        return tasksBuilder(
            tasks: tasks
        );
      },

    );
  }
}
