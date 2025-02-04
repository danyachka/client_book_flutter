

import 'package:client_book_flutter/blocks/appointment_list/entity.dart';

abstract class AppointmentListBlockState {}

class LoadingAppointmentListBlockState extends AppointmentListBlockState {}

class ListAppointmentListBlockState extends AppointmentListBlockState {

  final List<AppointmentListItem> list;

  ListAppointmentListBlockState({required this.list});
}