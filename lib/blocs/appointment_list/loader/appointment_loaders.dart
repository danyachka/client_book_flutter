

import 'package:client_book_flutter/model/app_database.dart';
import 'package:client_book_flutter/model/daos/appointment_dao.dart';
import 'package:client_book_flutter/model/models/appointment_client.dart';

abstract class AppointmentLoader {

  Future<AppointmentClient?> loadNear(int time);
  Future<List<AppointmentClient>> loadOlder(int oldestTime);
  Future<List<AppointmentClient>> loadNewer(int newestTime);
}

class MainAppointmentLoader extends AppointmentLoader {

  final dao = AppointmentDao(AppDatabase());
  
  @override
  Future<AppointmentClient?> loadNear(int time) => dao.getClosestACByTime(time);
  
  @override
  Future<List<AppointmentClient>> loadNewer(int newestTime) => dao.getACNewer(newestTime);
  
  @override
  Future<List<AppointmentClient>> loadOlder(int oldestTime) => dao.getACOlder(oldestTime);

}

class ClientAppointmentLoader extends AppointmentLoader {

  final dao = AppointmentDao(AppDatabase());

  final Client Function() getClient;

  ClientAppointmentLoader({
    required this.getClient
  });
  
  @override
  Future<AppointmentClient?> loadNear(int time) => dao.getClosestACByTimeAndClient(time, getClient().id);
  
  @override
  Future<List<AppointmentClient>> loadNewer(int newestTime) async {
    final client = getClient();

    return (await dao.getNewerByClient(newestTime, client.id))
      .map(
        (a) => AppointmentClient(appointment: a, client: client)
      ).toList();
  } 
  
  @override
  Future<List<AppointmentClient>> loadOlder(int oldestTime) async {
    final client = getClient();

    return (await dao.getOlderByClient(oldestTime, client.id))
      .map(
        (a) => AppointmentClient(appointment: a, client: client)
      ).toList();
  }

}