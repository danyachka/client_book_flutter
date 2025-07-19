import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/model/models/appointment/appointments.dart';
import 'package:client_book_flutter/core/model/models/appointment_client.dart';
import 'package:client_book_flutter/core/model/models/client/clients.dart';
import 'package:drift/drift.dart';

part 'appointment_dao.g.dart'; // Generated code

@DriftAccessor(tables: [Appointments, Clients])
class AppointmentDao extends DatabaseAccessor<AppDatabase> with _$AppointmentDaoMixin {
  AppointmentDao(super.attachedDatabase);


  static const loadingItemsCount = 50;

  // Insert methods
  Future<void> insertAll(List<AppointmentsCompanion> appointments) async {
    return await batch((batch) {
      batch.insertAll(this.appointments, appointments);
    });
  }

  Future<int> insertAppointment(AppointmentsCompanion appointment) async {
    return await into(appointments).insert(appointment);
  }

  // Update method
  Future<void> updateAppointment(Appointment appointment) async {
    await update(appointments).replace(appointment);
  }

  // Delete method
  Future<void> deleteAppointment(Appointment appointment) async {
    await delete(appointments).delete(appointment);
  }

  Future<void> deleteAll() async {
    return await batch((batch) {
      batch.deleteAll(appointments);
    });
  }

  // Get by ID
  Future<Appointment?> getById(int id) async {
    return await (select(appointments)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // Get older appointments by client
  Future<List<Appointment>> getOlderByClient(int startTime, int clientId) async {
    return await (select(appointments)
          ..where((t) => t.startTime.isSmallerThanValue(startTime) & t.clientId.equals(clientId))
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
          ..limit(loadingItemsCount))
        .get();
  }

  // Get newer appointments by client
  Future<List<Appointment>> getNewerByClient(int startTime, int clientId) async {
    return await (select(appointments)
          ..where((t) => t.startTime.isBiggerThanValue(startTime) & t.clientId.equals(clientId))
          ..orderBy([(t) => OrderingTerm.asc(t.startTime)])
          ..limit(loadingItemsCount))
        .get();
  }

  // Get closest AppointmentClient by time
  Future<AppointmentClient?> getClosestACByTime(int startTime) async {
    final query = (select(appointments)
      ..orderBy([
        (appointment) => OrderingTerm.asc(appointment.startTime - Variable.withInt(startTime).abs())
      ])
      ..limit(1) 
    ).join([
      innerJoin(clients, clients.id.equalsExp(appointments.clientId)),
    ]);

    final result = await query.getSingleOrNull();
    if (result == null) return null;

    return AppointmentClient(
      appointment: result.readTable(appointments),
      client: result.readTable(clients),
    );
  }

  // Get AppointmentClient between two times
  Future<AppointmentClient?> getBetween(int startTime, int endTime) async {
    final query = (select(appointments)
      ..where((t) =>
          t.startTime.isSmallerThanValue(endTime) & t.endTime.isBiggerThanValue(startTime))
    ).join([
      innerJoin(clients, clients.id.equalsExp(appointments.clientId)),
    ]);

    final result = await query.getSingleOrNull();
    if (result == null) return null;

    return AppointmentClient(
      appointment: result.readTable(appointments),
      client: result.readTable(clients),
    );
  }

  // Get AppointmentClient between two times where ID is not equal to a given ID
  Future<AppointmentClient?> getBetweenWhereIdNot(int startTime, int endTime, int id) async {
    final query = (select(appointments)
      ..where((t) =>
          t.startTime.isBiggerThanValue(startTime) &
          t.endTime.isSmallerThanValue(endTime) &
          t.id.isNotValue(id))
    ).join([
      innerJoin(clients, clients.id.equalsExp(appointments.clientId)),
    ]);

    final result = await query.getSingleOrNull();
    if (result == null) return null;

    return AppointmentClient(
      appointment: result.readTable(appointments),
      client: result.readTable(clients),
    );
  }

  // Get closest AppointmentClient by time and client
  Future<AppointmentClient?> getClosestACByTimeAndClient(int startTime, int clientId) async {
    final query = (select(appointments)
      ..where((t) => t.clientId.equals(clientId))
      ..orderBy([
        (appointment) => OrderingTerm.asc(appointment.startTime - Variable.withInt(startTime).abs())
      ])
      ..limit(1)
    ).join([
      innerJoin(clients, clients.id.equalsExp(appointments.clientId)),
    ]);

    final result = await query.getSingleOrNull();
    if (result == null) return null;

    return AppointmentClient(
      appointment: result.readTable(appointments),
      client: result.readTable(clients),
    );
  }

  // Get AppointmentClient by ID
  Future<AppointmentClient?> getACById(int id) async {
    final query = (select(appointments)
      ..where((t) => t.id.equals(id))
    ).join([
      innerJoin(clients, clients.id.equalsExp(appointments.clientId)),
    ]);

    final result = await query.getSingleOrNull();
    if (result == null) return null;

    return AppointmentClient(
      appointment: result.readTable(appointments),
      client: result.readTable(clients),
    );
  }

  // Get all AppointmentClients by client ID
  Future<List<AppointmentClient>> getACAllByClientId(int clientId) async {
    final query = (select(appointments)
      ..where((t) => t.clientId.equals(clientId))
    ).join([
      innerJoin(clients, clients.id.equalsExp(appointments.clientId)),
    ]);

    final results = await query.get();
    return results
        .map((row) => AppointmentClient(
              appointment: row.readTable(appointments),
              client: row.readTable(clients),
            ))
        .toList();
  }

  // Get older AppointmentClients
  Future<List<AppointmentClient>> getACOlder(int startTime) async {
    final query = (select(appointments)
      ..where((t) => t.startTime.isSmallerThanValue(startTime))
      ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
      ..limit(loadingItemsCount)
    ).join([
      innerJoin(clients, clients.id.equalsExp(appointments.clientId)),
    ]);

    final results = await query.get();
    return results
        .map((row) => AppointmentClient(
              appointment: row.readTable(appointments),
              client: row.readTable(clients),
            ))
        .toList();
  }

  // Get newer AppointmentClients
  Future<List<AppointmentClient>> getACNewer(int startTime) async {
    final query = (select(appointments)
      ..where((t) => t.startTime.isBiggerThanValue(startTime))
      ..orderBy([(t) => OrderingTerm.asc(t.startTime)])
      ..limit(loadingItemsCount)
    ).join([
      innerJoin(clients, clients.id.equalsExp(appointments.clientId)),
    ]);

    final results = await query.get();
    return results
        .map((row) => AppointmentClient(
              appointment: row.readTable(appointments),
              client: row.readTable(clients),
            ))
        .toList();
  }

  // Get all appointments by client ID
  Future<List<Appointment>> getAllByClientId(int clientId) async {
    return await (select(appointments)..where((t) => t.clientId.equals(clientId))).get();
  }

  // Count newer appointments for a client
  Future<int> countNewerForClient(int clientId, int time) async {
    return await (select(appointments)
          ..where((t) => t.clientId.equals(clientId) & t.startTime.isBiggerThanValue(time)))
        .get()
        .then((value) => value.length);
  }

  // Count older appointments for a client
  Future<int> countOlderForClient(int clientId, int time) async {
    return await (select(appointments)
          ..where((t) => t.clientId.equals(clientId) & t.startTime.isSmallerOrEqualValue(time)))
        .get()
        .then((value) => value.length);
  }
}