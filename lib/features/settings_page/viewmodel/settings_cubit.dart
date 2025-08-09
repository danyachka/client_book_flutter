

import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/model/daos/appointment_dao.dart';
import 'package:client_book_flutter/core/model/daos/client_dao.dart';
import 'package:client_book_flutter/core/model/models/appointment/notification_type.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

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
      _insertData(text);
    } catch (e) {
      final es = e.toString();
      Logger().w("Error on updating db, ${es.substring(max(0, es.length - 1000))}");
      emit(state.copyWith(clearingState: SettingOptionState.error));
      return;
    }

    emit(state.copyWith(clearingState: SettingOptionState.success));
  }

}

void _insertData(String text) async {
  final map = await compute(jsonDecode, text);

  final clients = map["clients"] as List<dynamic>;
  final appointments = map["appointments"] as List<dynamic>;

  final appointmentDao = AppointmentDao(AppDatabase());
  final clientsDao = ClientDao(AppDatabase());

  // filtered appointments map
  final filteredAppointments = _getFilteredAppointmentsList(appointments);

  for (final clientMap in clients) {
    try {
      final oldClientId = clientMap['id'];

      final client = ClientsCompanion.insert(
          name: clientMap['name'] ?? "name",
          phoneNumber: Value(clientMap['phoneNumber'] ?? ""));

      final clientId = await clientsDao.insertClient(client);
      final thisClientAppointments = filteredAppointments[oldClientId];
      if (thisClientAppointments == null) continue;

      await appointmentDao.insertAll(thisClientAppointments
          .map((el) {
            var value = el['value'];
            if (value == null) {
              value = 0.0;
            } else if (value is int) {
              value = value.toDouble();
            } else if (value !is double) {
              value = 0.0;
            }

            return AppointmentsCompanion.insert(
                clientId: clientId,
                appointmentText: Value(el['text'] ?? "text"),
                value: Value(value),
                startTime: el['startTime'],
                endTime: el['endTime'],
                notificationStatus: const Value(NotificationStatus.enabled),
              );
          })
          .toList());
    } catch (e) {
      Logger().e("Could not inset client $clientMap", error: e);
    }
  }
}

HashMap<int, List<dynamic>> _getFilteredAppointmentsList(List<dynamic> appointments) {
  final filteredAppointments = HashMap<int, List<dynamic>>();
  for (final appointmentMap in appointments) {
    final clientId = appointmentMap["clientId"];
    final list = filteredAppointments[clientId];
    if (list == null) {
      filteredAppointments[clientId] = [appointmentMap];
      continue;
    }
    list.add(appointmentMap);
  }

  return filteredAppointments;
}
