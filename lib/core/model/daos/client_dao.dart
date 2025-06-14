import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/model/models/client/clients.dart';
import 'package:drift/drift.dart';

part 'client_dao.g.dart'; // Generated code

@DriftAccessor(tables: [Clients])
class ClientDao extends DatabaseAccessor<AppDatabase> with _$ClientDaoMixin {
  ClientDao(super.attachedDatabase);

  static const int loadingCount = 20; // Equivalent to LOADING_COUNT

  // Insert methods
  Future<void> insertAll(List<Client> clients) async {
    await batch((batch) {
      batch.insertAll(this.clients, clients);
    });
  }

  Future<int> insertClient(ClientsCompanion client) async {
    return await into(clients).insert(client);
  }

  // Update method
  Future<void> updateClient(Client client) async {
    await update(clients).replace(client);
  }

  // Delete method
  Future<void> deleteClient(Client client) async {
    await delete(clients).delete(client);
  }

  Future<void> deleteAll() async {
    return await batch((batch) {
      batch.deleteAll(clients);
    });
  }

  // Get by ID
  Future<Client?> getById(int id) async {
    return await (select(clients)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // Get by name
  Future<Client?> getByName(String name) async {
    return await (select(clients)..where((t) => t.name.equals(name))).getSingleOrNull();
  }

  // Get by phone
  Future<Client?> getByPhone(String phone) async {
    return await (select(clients)..where((t) => t.phoneNumber.equals(phone))).getSingleOrNull();
  }

  // Get latest clients by phone part
  Future<List<Client>> getLatestByPhone(String phonePart) async {
    return await (select(clients)
          ..where((t) => t.phoneNumber.like('%$phonePart%'))
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(loadingCount))
        .get();
  }

  // Get next clients by phone part
  Future<List<Client>> getNextByPhone(String phonePart, int id) async {
    return await (select(clients)
          ..where((t) => t.phoneNumber.like('%$phonePart%') & t.id.isSmallerThanValue(id))
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(loadingCount))
        .get();
  }

  // Get previous clients by phone part
  Future<List<Client>> getPreviousByPhone(String phonePart, int id) async {
    return await (select(clients)
          ..where((t) => t.phoneNumber.like('%$phonePart%') & t.id.isBiggerThanValue(id))
          ..orderBy([(t) => OrderingTerm.asc(t.id)])
          ..limit(loadingCount))
        .get();
  }

  // Get latest clients by name
  Future<List<Client>> getLatestByName(String name) async {
    return await (select(clients)
          ..where((t) => t.name.like('%$name%'))
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(loadingCount))
        .get();
  }

  // Get next clients by name
  Future<List<Client>> getNextByName(String name, int id) async {
    return await (select(clients)
          ..where((t) => t.name.like('%$name%') & t.id.isSmallerThanValue(id))
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(loadingCount))
        .get();
  }

  // Get previous clients by name
  Future<List<Client>> getPreviousByName(String name, int id) async {
    return await (select(clients)
          ..where((t) => t.name.like('%$name%') & t.id.isBiggerThanValue(id))
          ..orderBy([(t) => OrderingTerm.asc(t.id)])
          ..limit(loadingCount))
        .get();
  }
}