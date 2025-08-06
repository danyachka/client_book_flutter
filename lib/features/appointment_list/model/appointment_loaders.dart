

import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/model/daos/appointment_dao.dart';
import 'package:client_book_flutter/core/model/models/appointment_client.dart';

abstract class AppointmentLoader {

  final _dao = AppointmentDao(AppDatabase());

  Future<AppointmentClient?> loadNear(int time);
  Future<List<AppointmentClient>> loadOlder(int oldestTime);
  Future<List<AppointmentClient>> loadNewer(int newestTime);

  Future<void> removeAppointment(Appointment appointment) => _dao.deleteAppointment(appointment);
}

class MainAppointmentLoader extends AppointmentLoader {
  
  @override
  Future<AppointmentClient?> loadNear(int time) => _dao.getClosestACByTime(time);
  
  @override
  Future<List<AppointmentClient>> loadNewer(int newestTime) => _dao.getACNewer(newestTime);
  
  @override
  Future<List<AppointmentClient>> loadOlder(int oldestTime) => _dao.getACOlder(oldestTime);

}

class ClientAppointmentLoader extends AppointmentLoader {

  final Client Function() getClient;

  ClientAppointmentLoader({
    required this.getClient
  });
  
  @override
  Future<AppointmentClient?> loadNear(int time) => _dao.getClosestACByTimeAndClient(time, getClient().id);
  
  @override
  Future<List<AppointmentClient>> loadNewer(int newestTime) async {
    final client = getClient();

    return (await _dao.getNewerByClient(newestTime, client.id))
      .map(
        (a) => AppointmentClient(appointment: a, client: client)
      ).toList();
  } 
  
  @override
  Future<List<AppointmentClient>> loadOlder(int oldestTime) async {
    final client = getClient();

    return (await _dao.getOlderByClient(oldestTime, client.id))
      .map(
        (a) => AppointmentClient(appointment: a, client: client)
      ).toList();
  }

}