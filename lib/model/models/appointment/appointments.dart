
import 'package:client_book_flutter/model/models/appointment/notification_type.dart';
import 'package:drift/drift.dart';

class Appointments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get clientId => integer()();
  IntColumn get startTime => integer()();
  IntColumn get endTime => integer()();
  TextColumn get notificationStatus => text().map(const NotificationStatusConverter()).withDefault(Constant(NotificationStatus.enabled.name))();
  RealColumn get value => real().withDefault(const Constant(0))();
  TextColumn get appointmentText => text().withDefault(const Constant(''))();
}