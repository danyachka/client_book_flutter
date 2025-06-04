

import 'package:client_book_flutter/core/model/models/appointment_client.dart';
import 'package:flutter/widgets.dart';

class AppointmentListItem {

  final AppointmentClient data;

  GlobalKey? key; // sets in ui if null

  AppointmentListItem({required this.data});

}