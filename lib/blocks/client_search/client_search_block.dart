

import 'package:client_book_flutter/blocks/client_search/client_search_loaders.dart';
import 'package:client_book_flutter/blocks/client_search/client_search_type.dart';
import 'package:client_book_flutter/blocks/client_search/events/client_search_block_events.dart';
import 'package:client_book_flutter/blocks/client_search/state/client_search_block_state.dart';
import 'package:client_book_flutter/model/app_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientSearchBlock extends Bloc<ClientSearchBlockEvent, ClientSearchBlockState> {
  
  ClientSearchLoader _loader = NameClientSearchLoader();
  
  ClientSearchBlock(): super(ClientSearchBlockState(
    list: [],
    searchType: ClientSearchType.name,
    query: ''
  )) {
    on<NewQueryClientSearchBlockEvent>((event, emit) => _onNewQuery(event.query, emit));
    on<SearchTypeSwitchedClientSearchBlockEvent>((event, emit) => _onSearchTypeSwitched(event.type, emit));
    on<LastScrolledClientSearchBlockEvent>((event, emit) => _onLastScrolled(event.clientId, emit));
  }

  void _onNewQuery(String newQuery, Emitter<ClientSearchBlockState> emit) async {
    final lastState = state;

    if (lastState.query == newQuery) return;

    final newList = await _loader.getLatest(newQuery);
    emit(ClientSearchBlockState(list: newList, query: lastState.query, searchType: lastState.searchType));
  }

  void _onSearchTypeSwitched(ClientSearchType newType, Emitter<ClientSearchBlockState> emit) async {
    final lastState = state;
    if (lastState.searchType == newType) return;

    if (newType == ClientSearchType.name) {
      _loader = NameClientSearchLoader();
    } else {
      _loader = PhoneClientSearchLoader();
    }

    final newList = await _loader.getLatest('');
    emit(ClientSearchBlockState(list: newList, query: '', searchType: newType));

  }

  void _onLastScrolled(int lastId, Emitter<ClientSearchBlockState> emit) async {
    final lastState = state;
    if (lastState.isBottomLoaded) return;

    final newList = await _loader.getNext(lastState.query, lastState.list.last.id);

    if (newList.isEmpty) {
      lastState.isBottomLoaded = true;
      return;
    }

    final finalNewList = <Client>[];
    finalNewList.addAll(lastState.list);
    finalNewList.addAll(newList);

    emit(ClientSearchBlockState(
      list: finalNewList, 
      query: lastState.query, 
      searchType: lastState.searchType
    ));
  }

}