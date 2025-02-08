

import 'package:client_book_flutter/model/app_database.dart';

abstract class ClientCreationState {}

class DoneClientCreationState extends ClientCreationState {
  final Client createdClient;

  DoneClientCreationState({required this.createdClient});
}

class LoadingClientCreationState extends ClientCreationState {}

class UnknownErrorClientCreationState extends ClientCreationState {
  final String errorText;

  UnknownErrorClientCreationState({required this.errorText});
}

class CreationClientCreationState extends ClientCreationState {

   final ClientCreationErrorType nameError;
   final ClientCreationErrorType phoneError;

   final String? unknownError;

  CreationClientCreationState({required this.nameError, required this.phoneError, this.unknownError});

  CreationClientCreationState.nothing()
  : nameError = ClientCreationErrorType.nothing, phoneError = ClientCreationErrorType.nothing, unknownError = null;
}

enum ClientCreationErrorType {
  clientExists,

  noInput,

  nothing
}