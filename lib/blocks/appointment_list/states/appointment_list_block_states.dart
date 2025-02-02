

import 'package:client_book_flutter/model/models/appointment_client.dart';

abstract class AppointmentListBlockState {}

class LoadingAppointmentListBlockState extends AppointmentListBlockState {}

class ListAppointmentListBlockState extends AppointmentListBlockState {

  final List<AppointmentClient> list;

  ListAppointmentListBlockState({required this.list});
}