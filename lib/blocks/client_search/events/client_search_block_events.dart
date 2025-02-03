

import 'package:client_book_flutter/blocks/client_search/client_search_type.dart';

abstract class ClientSearchBlockEvent {}

class NewQueryClientSearchBlockEvent extends ClientSearchBlockEvent {

  final String query;

  NewQueryClientSearchBlockEvent({required this.query});
}

class SearchTypeSwitchedClientSearchBlockEvent extends ClientSearchBlockEvent {

  final ClientSearchType type;

  SearchTypeSwitchedClientSearchBlockEvent({required this.type});
}

class LastScrolledClientSearchBlockEvent extends ClientSearchBlockEvent {

  final int clientId;

  LastScrolledClientSearchBlockEvent({required this.clientId});
}