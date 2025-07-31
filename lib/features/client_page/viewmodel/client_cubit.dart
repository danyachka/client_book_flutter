
import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientState {
  final Client client;

  ClientState({required this.client});
}


class ClientCubit extends Cubit<ClientState> {

  final OnClientUpdated _onClientUpdated;
  Client? _updatedClient;

  ClientCubit({required Client client, required OnClientUpdated onClientUpdatedCallBack}) 
  : _onClientUpdated = onClientUpdatedCallBack, super(ClientState(client: client));

  @override
  Future<void> close() {
    if (_updatedClient != null) _onClientUpdated(_updatedClient!);
    return super.close();
  }

  void onClientUpdated(Client client) {
    _updatedClient = client;

    emit(ClientState(client: client));
  }

}

typedef OnClientUpdated = void Function(Client);