

import 'dart:convert';

import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/model/daos/appointment_dao.dart';
import 'package:client_book_flutter/core/model/daos/client_dao.dart';
import 'package:client_book_flutter/core/model/models/appointment/notification_type.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';

class SettingsCubitState {
  final SettingOptionState clearingState;
  final SettingOptionState updatingState;

  SettingsCubitState({required this.clearingState, required this.updatingState});

  SettingsCubitState copyWith({SettingOptionState? clearingState, SettingOptionState? updatingState}) {
    return SettingsCubitState(
      clearingState: clearingState ?? this.clearingState, 
      updatingState: updatingState ?? this.updatingState
    );
  }
}

enum SettingOptionState {
  nothing,
  loading,
  success,
  error
}

class SettingsCubit extends Cubit<SettingsCubitState> {
  
  SettingsCubit() : super(SettingsCubitState(
    clearingState: SettingOptionState.nothing,
    updatingState: SettingOptionState.nothing
  ));

  void clearDb() async {
    emit(state.copyWith(clearingState: SettingOptionState.loading));
    await Future.wait([AppointmentDao(AppDatabase()).deleteAll(), ClientDao(AppDatabase()).deleteAll()]);
    emit(state.copyWith(clearingState: SettingOptionState.success));
  }

  void updateDb(String text) async {
    emit(state.copyWith(updatingState: SettingOptionState.loading));

    try {
      final map = await compute(jsonDecode, text) as Map<String, dynamic>;
      final clients = map["clients"] as List<Map<String, dynamic>>;
      final appointments = map["appointments"] as List<Map<String, dynamic>>;
      
      await compute(_insertData, [clients, appointments]);
    } catch (e) {
      Logger().w("Error on updating db", error: e);
      emit(state.copyWith(clearingState: SettingOptionState.error));
      return;
    }

    emit(state.copyWith(clearingState: SettingOptionState.success));
  }

  Future<void> _insertData(List<List<Map<String, dynamic>>> data) async {
    final [clients, appointments] = data;
    final appointmentDao = AppointmentDao(AppDatabase());
    final clientsDao = ClientDao(AppDatabase());

    for (final clientMap in clients) {
      final oldClientId = clientMap['id'];

      final client = ClientsCompanion.insert(
        name: clientMap['name'],
        phoneNumber: clientMap['phoneNumber']
      );

      final clientId = await clientsDao.insertClient(client);
      final thisClientAppointments = appointments.where((el) => el['clientId'] == oldClientId);
      
      // TODO: Check fields names
      await appointmentDao.insertAll(thisClientAppointments.map((el) => AppointmentsCompanion.insert(
          clientId: clientId,
          appointmentText: el['text'],
          value: el['value'],
          startTime: el['startTime'], 
          endTime: el['endTime'],
          notificationStatus: const Value(NotificationStatus.enabled),
        )
      ).toList());
    }
  }

}