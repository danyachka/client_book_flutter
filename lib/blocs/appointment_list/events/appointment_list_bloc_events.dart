

import 'package:client_book_flutter/model/app_database.dart';

abstract class AppointmentListBlocEvent {}

class ScrollToDateAppointmentListBlocEvent extends AppointmentListBlocEvent {

  final int time;

  ScrollToDateAppointmentListBlocEvent({required this.time});
}

class OldestScrolledAppointmentListBlocEvent extends AppointmentListBlocEvent {

  final int lastAppointmentTime;

  OldestScrolledAppointmentListBlocEvent({required this.lastAppointmentTime});
}

class NewestScrolledAppointmentListBlocEvent extends AppointmentListBlocEvent {

  final int newestAppointmentTime;

  NewestScrolledAppointmentListBlocEvent({required this.newestAppointmentTime});
}

class AppointmentChangedAppointmentListBlocEvent extends AppointmentListBlocEvent {

  final Appointment changedAppointment;

  AppointmentChangedAppointmentListBlocEvent({required this.changedAppointment});
}

class ClientChangedAppointmentListBlocEvent extends AppointmentListBlocEvent {

  final Client changedClient;

  ClientChangedAppointmentListBlocEvent({required this.changedClient});
}

class AppointmentRemovedAppointmentListBlocEvent extends AppointmentListBlocEvent {

  final Appointment removedAppointment;

  AppointmentRemovedAppointmentListBlocEvent({required this.removedAppointment});
}