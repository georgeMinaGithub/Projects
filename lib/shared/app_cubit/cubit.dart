
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todo_app_flutter/network/cach_helper.dart';
import 'package:todo_app_flutter/shared/app_cubit/states.dart';

class ModeCubit extends Cubit<ModeStates> {
  ModeCubit() : super(ModeInitialState());

  static ModeCubit get(context) => BlocProvider.of(context);

  bool isDark = false;
  Color backgroundColor = Colors.white;
  void changeAppMode({bool? fromShared}) {
    if (fromShared == null)
    {
      isDark = !isDark;
    }
    else
    {
      isDark = fromShared;
    }
    CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value)
    {
      if (isDark)
      {
        backgroundColor = HexColor('333739').withOpacity(0.8);
        emit(AppChangeModeState());
      }
      else
      {
        backgroundColor = Colors.white;
        emit(AppChangeModeState());
      }
      emit(AppChangeModeState());
    });
  }
}
