

import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/model/models/appointment_client.dart';

abstract class AppointmentListBlocEvent {}

class ScrollToDateAppointmentListBlocEvent extends AppointmentListBlocEvent {

  final int time;

  final bool animate;

  ScrollToDateAppointmentListBlocEvent({required this.time, this.animate = true});
}

class OldestScrolledAppointmentListBlocEvent extends AppointmentListBlocEvent {

  final int lastAppointmentTime;

  OldestScrolledAppointmentListBlocEvent({required this.lastAppointmentTime});
}

class NewestScrolledAppointmentListBlocEvent extends AppointmentListBlocEvent {

  final int newestAppointmentTime;

  NewestScrolledAppointmentListBlocEvent({required this.newestAppointmentTime});
}

class AppointmentAddedAppointmentListBlocEvent extends AppointmentListBlocEvent {

  final AppointmentClient newAppointment;

  AppointmentAddedAppointmentListBlocEvent({required this.newAppointment});
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

  final bool processFromDbRemoving;

  AppointmentRemovedAppointmentListBlocEvent({required this.removedAppointment, required this.processFromDbRemoving});
}