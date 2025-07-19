

import 'package:client_book_flutter/core/model/models/appointment_client.dart';

class AppointmentListItem {

  final AppointmentClient data;

  AppointmentListItem({required this.data});

  String getKey() => "${data.client.id}:${data.appointment.id}";
}