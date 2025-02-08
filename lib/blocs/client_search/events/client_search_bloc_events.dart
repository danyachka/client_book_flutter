

abstract class ClientSearchBlocEvent {}

class NewQueryClientSearchBlocEvent extends ClientSearchBlocEvent {

  final String query;

  NewQueryClientSearchBlocEvent({required this.query});
}

class ClientUpdatedOrAddedClientSearchBlocEvent extends ClientSearchBlocEvent {}

class SearchTypeSwitchedClientSearchBlocEvent extends ClientSearchBlocEvent {}

class LastScrolledClientSearchBlocEvent extends ClientSearchBlocEvent {

  final int clientId;

  LastScrolledClientSearchBlocEvent({required this.clientId});
}