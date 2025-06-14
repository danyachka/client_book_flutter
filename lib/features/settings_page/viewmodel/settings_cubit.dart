

import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/model/daos/appointment_dao.dart';
import 'package:client_book_flutter/core/model/daos/client_dao.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubitState {}

class SettingsCubit extends Cubit<SettingsCubitState> {
  
  SettingsCubit() : super(SettingsCubitState());

  void clearDb() async {
    AppointmentDao(AppDatabase()).deleteAll();
    ClientDao(AppDatabase()).deleteAll();
  }

}