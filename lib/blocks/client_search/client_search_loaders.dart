
import 'package:client_book_flutter/model/app_database.dart';
import 'package:client_book_flutter/model/daos/client_dao.dart';

abstract class ClientSearchLoader {

  final ClientDao _dao = ClientDao(AppDatabase());

  Future<List<Client>> getLatest(String query);

  Future<List<Client>> getNext(String query, int lastClientId);
}

class NameClientSearchLoader extends ClientSearchLoader{

  @override
  Future<List<Client>> getLatest(String query) => _dao.getLatestByName(query);
  
  @override
  Future<List<Client>> getNext(String query, int lastClientId) => _dao.getNextByName(query, lastClientId);
}

class PhoneClientSearchLoader extends ClientSearchLoader {

  @override
  Future<List<Client>> getLatest(String query) => _dao.getLatestByPhone(query);

  @override
  Future<List<Client>> getNext(String query, int lastClientId) => _dao.getNextByPhone(query, lastClientId);
}