

import 'package:client_book_flutter/features/client_search/model/client_search_loaders.dart';
import 'package:client_book_flutter/features/client_search/viewmodel/client_search_type.dart';
import 'package:client_book_flutter/features/client_search/viewmodel/events/client_search_bloc_events.dart';
import 'package:client_book_flutter/features/client_search/viewmodel/state/client_search_bloc_state.dart';
import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientSearchBloc extends Bloc<ClientSearchBlocEvent, ClientSearchBlocState> {
  
  ClientSearchLoader _loader = NameClientSearchLoader();
  
  ClientSearchBloc(): super(ClientSearchBlocState(
    list: [],
    searchType: ClientSearchType.name,
    query: 'startQuery'
  )) {
    on<NewQueryClientSearchBlocEvent>((event, emit) => _onNewQuery(event.query, emit));
    on<ClientUpdatedOrAddedClientSearchBlocEvent>((event, emit) => _onClientAddedOrUpdated(emit));
    on<SearchTypeSwitchedClientSearchBlocEvent>((event, emit) => _onSearchTypeSwitched(emit));
    on<LastScrolledClientSearchBlocEvent>((event, emit) => _onLastScrolled(event.clientId, emit));

    add(NewQueryClientSearchBlocEvent(query: ''));
  }

  void _onNewQuery(String newQuery, Emitter<ClientSearchBlocState> emit) async {
    final lastState = state;

    if (lastState.query == newQuery) return;

    final newList = await _loader.getLatest(newQuery);
    emit(ClientSearchBlocState(list: newList, query: newQuery, searchType: lastState.searchType));
  }

  void _onClientAddedOrUpdated(Emitter<ClientSearchBlocState> emit) async {
    final lastState = state;

    final newList = await _loader.getLatest(lastState.query);
    emit(ClientSearchBlocState(list: newList, query: lastState.query, searchType: lastState.searchType));
  }

  void _onSearchTypeSwitched(Emitter<ClientSearchBlocState> emit) async {
    final lastState = state;
    final newType = lastState.searchType == ClientSearchType.name? ClientSearchType.phone: ClientSearchType.name;

    if (newType == ClientSearchType.name) {
      _loader = NameClientSearchLoader();
    } else {
      _loader = PhoneClientSearchLoader();
    }

    final newList = await _loader.getLatest('');
    emit(ClientSearchBlocState(list: newList, query: '', searchType: newType));
  }

  void _onLastScrolled(int lastId, Emitter<ClientSearchBlocState> emit) async {
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

    emit(ClientSearchBlocState(
      list: finalNewList, 
      query: lastState.query, 
      searchType: lastState.searchType
    ));
  }

}