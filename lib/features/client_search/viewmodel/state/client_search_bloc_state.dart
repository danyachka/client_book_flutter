

import 'package:client_book_flutter/features/client_search/viewmodel/client_search_type.dart';
import 'package:client_book_flutter/core/model/app_database.dart';

class ClientSearchBlocState {

  final List<Client> list;

  final String query;

  final ClientSearchType searchType;

  bool isBottomLoaded;

  ClientSearchBlocState({
    required this.list, 
    required this.query,
    required this.searchType,
    this.isBottomLoaded = false
  });
}