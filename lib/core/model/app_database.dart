import 'dart:io';

import 'package:client_book_flutter/core/model/daos/appointment_dao.dart';
import 'package:client_book_flutter/core/model/daos/client_dao.dart';
import 'package:client_book_flutter/core/model/daos/expenses_dao.dart';
import 'package:client_book_flutter/core/model/models/appointment/appointments.dart';
import 'package:client_book_flutter/core/model/models/appointment/notification_type.dart';
import 'package:client_book_flutter/core/model/models/client/clients.dart';
import 'package:client_book_flutter/core/model/models/expense/expenses.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Appointments, Clients, Expenses],
  daos: [AppointmentDao, ClientDao, ExpensesDao]  
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(_openConnection());

  static AppDatabase? _instance;

  factory AppDatabase() {
    _instance ??= AppDatabase._();
    return _instance!;
  }

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}