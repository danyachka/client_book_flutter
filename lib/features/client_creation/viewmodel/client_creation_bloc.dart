
import 'package:client_book_flutter/features/client_creation/viewmodel/events/client_creation_event.dart';
import 'package:client_book_flutter/features/client_creation/viewmodel/states/client_creation_state.dart';
import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/model/daos/client_dao.dart';
import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientCreationBloc extends Bloc<ClientCreationEvent, ClientCreationState> {

  final int? editClientId;
  final dao = ClientDao(AppDatabase());

  ClientCreationBloc({this.editClientId}): super(CreationClientCreationState.nothing()) {
    on<ClientCreationEvent>(_onCreationEvent);
  }

  void _onCreationEvent(ClientCreationEvent event, Emitter<ClientCreationState> emit) async {
    ClientCreationErrorType nameError = 
      event.name.isEmpty? ClientCreationErrorType.noInput
      : ClientCreationErrorType.nothing;

    if (nameError == ClientCreationErrorType.noInput) {
      emit(CreationClientCreationState(
        nameError: nameError,
        phoneError: ClientCreationErrorType.nothing
      ));
      return;
    }

    emit(LoadingClientCreationState());

    Client? sameNameClient, samePhoneClient;

    if (event.phone.isNotEmpty) {
      [sameNameClient, samePhoneClient] = await Future.wait([
        dao.getByNameIgnoreCase(event.name),
        dao.getByPhone(event.phone)
      ]);
    } else {
      sameNameClient = await dao.getByNameIgnoreCase(event.name);
      samePhoneClient = null;
    }

    nameError = (sameNameClient != null && sameNameClient.id != editClientId)? ClientCreationErrorType.clientExists
      : ClientCreationErrorType.nothing;
    ClientCreationErrorType phoneError = (samePhoneClient != null && samePhoneClient.id != editClientId)? ClientCreationErrorType.clientExists
      : ClientCreationErrorType.nothing;

    // if has errors
    if (nameError == ClientCreationErrorType.clientExists || 
        phoneError == ClientCreationErrorType.clientExists) { // if client already exists
      emit(CreationClientCreationState(
        nameError: nameError,
        phoneError: phoneError
      ));
      return;
    }

    try { // try to insert
      Client client;
      if (editClientId != null) {
        client = await _updateClient(event);
      } else {
        client = await _createClient(event);
      }

      emit(DoneClientCreationState(
        createdClient: client
      ));
    } catch (e) {
      emit(UnknownErrorClientCreationState(errorText: e.toString()));
    }
    
  }

  Future<Client> _updateClient(ClientCreationEvent event) async {
    final client = Client(
        id: editClientId!,
        name: event.name,
        phoneNumber: event.phone,
        picturePath: ''
    );

    await dao.updateClient(client);
    return client;
  }

  Future<Client> _createClient(ClientCreationEvent event) async {
    final clientCompanion = ClientsCompanion.insert(
        id: editClientId == null? const Value.absent() : Value(editClientId!),
        name: event.name,
        phoneNumber: Value(event.phone)
    );

    final id = await dao.insertClient(clientCompanion);
    return Client(
        id: id,
        name: event.name,
        phoneNumber: event.phone,
        picturePath: ''
    );
  }

}