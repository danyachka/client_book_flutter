
import 'package:client_book_flutter/features/client_creation/viewmodel/events/client_creation_event.dart';
import 'package:client_book_flutter/features/client_creation/viewmodel/states/client_creation_state.dart';
import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/model/daos/client_dao.dart';
import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientCreationBloc extends Bloc<ClientCreationEvent, ClientCreationState> {

  final dao = ClientDao(AppDatabase());

  ClientCreationBloc(): super(CreationClientCreationState.nothing()) {
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
        dao.getByName(event.name),
        dao.getByPhone(event.phone)
      ]);
    } else {
      sameNameClient = await dao.getByName(event.name);
      samePhoneClient = null;
    }

    nameError = sameNameClient != null? ClientCreationErrorType.clientExists
      : ClientCreationErrorType.nothing;
    ClientCreationErrorType phoneError = samePhoneClient != null? ClientCreationErrorType.clientExists
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
      final clientCompanion = ClientsCompanion.insert(
        name: event.name,
        phoneNumber: Value(event.phone)
      );

      int id = await dao.insertClient(clientCompanion);

      final client = Client(
        id: id, 
        name: event.name,
        phoneNumber: event.phone,
        picturePath: ''
      );

      emit(DoneClientCreationState(
        createdClient: client
      ));
    } catch (e) {
      emit(UnknownErrorClientCreationState(errorText: e.toString()));
    }
    
  }

}