

import 'package:client_book_flutter/blocks/client_search/client_search_type.dart';
import 'package:client_book_flutter/model/app_database.dart';

class ClientSearchBlockState {

  final List<Client> list;

  final String query;

  final ClientSearchType searchType;

  bool isBottomLoaded;

  ClientSearchBlockState({
    required this.list, 
    required this.query,
    required this.searchType,
    this.isBottomLoaded = false
  });
}