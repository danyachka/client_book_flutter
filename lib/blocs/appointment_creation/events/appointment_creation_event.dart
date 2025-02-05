

import 'package:client_book_flutter/model/app_database.dart';
import 'package:client_book_flutter/model/models/appointment/notification_type.dart';

class AppointmentCreationEvent {

  final Client? client;

  final DateTime startTime;
  final Duration duration;

  final NotificationStatus status;
  
  final double? value;
  final String text;

  AppointmentCreationEvent({
    required this.client, 
    required this.startTime, 
    required this.duration, 
    required this.status, 
    required this.value, 
    required this.text
  });
}