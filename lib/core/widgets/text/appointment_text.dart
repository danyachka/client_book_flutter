

import 'package:client_book_flutter/core/model/models/appointment_client.dart';
import 'package:client_book_flutter/core/utils/time_utils.dart';


extension AppointmentText on AppointmentClient {
  String getInfoText() {
    final start = DateTime.fromMillisecondsSinceEpoch(appointment.startTime);
    final end = DateTime.fromMillisecondsSinceEpoch(appointment.endTime);
    
    return "${client.name}, \"${appointment.appointmentText}\", ${start.getFormattedDayTime()} - ${end.getFormattedDayTime()}";
  }
}