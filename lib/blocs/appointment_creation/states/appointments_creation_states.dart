

import 'package:client_book_flutter/model/models/appointment_client.dart';

abstract class AppointmentCreationState {}

class DoneAppointmentCreationState extends AppointmentCreationState {
  final AppointmentClient createdAC;

  DoneAppointmentCreationState({required this.createdAC});
}

class LoadingAppointmentCreationState extends AppointmentCreationState {}

class CreationAppointmentCreationState extends AppointmentCreationState {

  final AppointmentCreationTimeError? timeRangeError;

  final bool hasNotCheckedClient;

  final bool hasNotCheckedValue;

  final bool hasNotCheckedText;

  final String? unknownDbError;

  CreationAppointmentCreationState.error({
    this.timeRangeError, 
    required this.hasNotCheckedClient, 
    required this.hasNotCheckedValue, 
    required this.hasNotCheckedText,
    this.unknownDbError
  });

  CreationAppointmentCreationState.unknownError(String text)
  : timeRangeError = null, hasNotCheckedClient = false, 
    hasNotCheckedText = false, hasNotCheckedValue = false,
    unknownDbError = text;

  CreationAppointmentCreationState.empty()
  : timeRangeError = null, hasNotCheckedClient = false, 
    hasNotCheckedText = false, hasNotCheckedValue = false,
    unknownDbError = null;

  bool get isAllFieldsLegal => !hasNotCheckedClient 
    && !hasNotCheckedText && !hasNotCheckedValue 
    && timeRangeError == null;

}

class AppointmentCreationTimeError {
  final AppointmentClient appointmentAtTime;

  AppointmentCreationTimeError({required this.appointmentAtTime});
}
