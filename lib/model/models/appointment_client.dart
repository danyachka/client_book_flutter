import 'package:client_book_flutter/model/app_database.dart';

class AppointmentClient {
  final Appointment appointment;
  final Client client;

  AppointmentClient({
    required this.appointment,
    required this.client,
  });
}