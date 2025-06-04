

import 'package:client_book_flutter/features/appointment_list/viewmodel/entity.dart';

abstract class AppointmentListBlocState {}

class LoadingAppointmentListBlockState extends AppointmentListBlocState {

  @override
  String toString() {
    return "LoadingAppointmentListBlockState";
  }
}

class ListAppointmentListBlocState extends AppointmentListBlocState {

  final List<AppointmentListItem> list;

  ListAppointmentListBlocState({required this.list});

  @override
  String toString() {
    return "ListAppointmentListBlockState(list.length = ${list.length})";
  }
}