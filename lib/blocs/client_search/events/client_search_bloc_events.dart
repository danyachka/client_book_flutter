

import 'package:client_book_flutter/blocs/client_search/client_search_type.dart';

abstract class ClientSearchBlocEvent {}

class NewQueryClientSearchBlocEvent extends ClientSearchBlocEvent {

  final String query;

  NewQueryClientSearchBlocEvent({required this.query});
}

class ClientUpdatedOrAddedClientSearchBlocEvent extends ClientSearchBlocEvent {}

class SearchTypeSwitchedClientSearchBlocEvent extends ClientSearchBlocEvent {

  final ClientSearchType type;

  SearchTypeSwitchedClientSearchBlocEvent({required this.type});
}

class LastScrolledClientSearchBlocEvent extends ClientSearchBlocEvent {

  final int clientId;

  LastScrolledClientSearchBlocEvent({required this.clientId});
}