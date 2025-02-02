

import 'package:client_book_flutter/model/app_database.dart';

abstract class AppointmentListBlockEvent {}

class ScrollToDateAppointmentListBlockEvent extends AppointmentListBlockEvent {

  final int time;

  ScrollToDateAppointmentListBlockEvent({required this.time});
}

class OldestScrolledAppointmentListBlockEvent extends AppointmentListBlockEvent {

  final int lastAppointmentTime;

  OldestScrolledAppointmentListBlockEvent({required this.lastAppointmentTime});
}

class NewestScrolledAppointmentListBlockEvent extends AppointmentListBlockEvent {

  final int newestAppointmentTime;

  NewestScrolledAppointmentListBlockEvent({required this.newestAppointmentTime});
}

class AppointmentChangedAppointmentListBlockEvent extends AppointmentListBlockEvent {

  final Appointment changedAppointment;

  AppointmentChangedAppointmentListBlockEvent({required this.changedAppointment});
}

class ClientChangedAppointmentListBlockEvent extends AppointmentListBlockEvent {

  final Client changedClient;

  ClientChangedAppointmentListBlockEvent({required this.changedClient});
}

class AppointmentRemovedAppointmentListBlockEvent extends AppointmentListBlockEvent {

  final Appointment removedAppointment;

  AppointmentRemovedAppointmentListBlockEvent({required this.removedAppointment});
}