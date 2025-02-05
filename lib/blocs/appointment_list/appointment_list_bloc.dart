
import 'dart:math';

import 'package:client_book_flutter/blocs/appointment_list/entity.dart';
import 'package:client_book_flutter/blocs/appointment_list/events/appointment_list_bloc_events.dart';
import 'package:client_book_flutter/blocs/appointment_list/loader/appointment_loaders.dart';
import 'package:client_book_flutter/blocs/appointment_list/states/appointment_list_bloc_states.dart';
import 'package:client_book_flutter/model/app_database.dart';
import 'package:client_book_flutter/model/daos/appointment_dao.dart';
import 'package:client_book_flutter/model/models/appointment_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


abstract class AppointmentListBloc 
    extends Bloc<AppointmentListBlocEvent, AppointmentListBlocState> {

  static const maxItemsInList = 200;

  final AppointmentLoader _loader;

  List<AppointmentListItem> get _list => (state as ListAppointmentListBlocState).list;

  final ScrollTo _scrollTo;
  
  AppointmentListBloc(AppointmentLoader loader, this._scrollTo)
  : _loader = loader, 
    super(LoadingAppointmentListBlockState()) {

    on<ScrollToDateAppointmentListBlocEvent>(
      (event, emit) => _onScrollToEvent(event.time, emit)
    );

    on<OldestScrolledAppointmentListBlocEvent>(
      (event, emit) => _onOldestScrolled(event.lastAppointmentTime, emit)
    );

    on<NewestScrolledAppointmentListBlocEvent>(
      (event, emit) => _onNewestScrolled(event.newestAppointmentTime, emit)
    );

    on<AppointmentChangedAppointmentListBlocEvent>(
      (event, emit) => _onAppointmentChanged(event.changedAppointment, emit)
    );

    on<ClientChangedAppointmentListBlocEvent>(
      (event, emit) => _onClientChanged(event.changedClient, emit)
    );

    on<AppointmentRemovedAppointmentListBlocEvent>(
      (event, emit) => _onAppointmentRemoved(event.removedAppointment, emit)
    );

    add(
      ScrollToDateAppointmentListBlocEvent(time: DateTime.now().millisecondsSinceEpoch)
    );
  }

  bool needToCheckEvent(int clientId);

  void _onScrollToEvent(int time, Emitter<AppointmentListBlocState> emit) async {
    final currentState = state;
    
    // in case scroll only
    if (currentState is ListAppointmentListBlocState) {
      final list = currentState.list;
      if (list.isNotEmpty) {
        if (list.first.data.appointment.startTime <= time && time <= list.last.data.appointment.startTime) {
          _scrollToTime(time, list);
          return;
        }
      } 

    }

    // in case nothing in db
    final centerItem = await _loader.loadNear(time);
    if (centerItem == null) {
      emit(ListAppointmentListBlocState(list: []));
      return;
    }

    // usual case
    int centerItemTime = centerItem.appointment.startTime;
    final lists = await Future.wait([_loader.loadNewer(centerItemTime), _loader.loadOlder(centerItemTime)]);
    
    int centerItemIndex = lists[0].length;
    final itemsList = lists[0]
      ..add(centerItem)
      ..addAll(lists[1]);
    
    emit(ListAppointmentListBlocState(
      list: itemsList.map((e) => AppointmentListItem(data: e)).toList()
    ));
    _scrollTo(centerItemIndex);
  }

  void _scrollToTime(int time, List<AppointmentListItem> list) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].data.appointment.startTime < time) continue;

      _scrollTo(max(0, i - 1));
    }
  }

  void _onNewestScrolled(int time, Emitter<AppointmentListBlocState> emit) async {
    final newData = await _loader.loadNewer(time);

    if (newData.isEmpty) return;
    final newItems = newData.map((e) => AppointmentListItem(data: e)).toList();

    final oldList = _list;

    oldList.addAll(newItems);

    List<AppointmentListItem> newList;
    if (oldList.length > maxItemsInList) {
      newList = oldList.sublist(0, AppointmentDao.loadingItemsCount);
    } else {
      newList = _list;
    }

    emit(ListAppointmentListBlocState(list: newList));
  }

  void _onOldestScrolled(int time, Emitter<AppointmentListBlocState> emit) async {
    final newData = await _loader.loadOlder(time);

    if (newData.isEmpty) return;
    final newItems = newData.map((e) => AppointmentListItem(data: e)).toList();

    final oldList = _list;

    oldList.addAll(newItems);

    List<AppointmentListItem> newList;
    if (oldList.length > maxItemsInList) {
      newList = oldList.sublist(maxItemsInList - AppointmentDao.loadingItemsCount);
    } else {
      newList = _list;
    }

    emit(ListAppointmentListBlocState(list: newList));
    
  }

  void _onAppointmentChanged(Appointment appointment, Emitter<AppointmentListBlocState> emit) async {
    if (!needToCheckEvent(appointment.clientId)) return;

    final list = _list;
    for (int i = 0; i < list.length; i++) {
      final ac = list[i];

      if (ac.data.appointment.id != appointment.id) continue;

      final newItem = AppointmentListItem(
        data: AppointmentClient(appointment: appointment, client: ac.data.client)
      );
      newItem.key = ac.key;

      list[i] = newItem;
      emit(ListAppointmentListBlocState(list: list));
      return;
    }
  }

  void _onClientChanged(Client client, Emitter<AppointmentListBlocState> emit) async {
    if (!needToCheckEvent(client.id)) return;
    bool hasChangedAny = false;

    final list = _list;
    for (int i = 0; i < list.length; i++) {
      final ac = list[i];

      if (ac.data.client.id != client.id) continue;

      list[i] = AppointmentListItem(
        data: AppointmentClient(appointment: ac.data.appointment, client: client)
      );
      hasChangedAny = true;
    }

    if (!hasChangedAny) return;
    emit(ListAppointmentListBlocState(list: list));
  }

  void _onAppointmentRemoved(Appointment removedAppointment, Emitter<AppointmentListBlocState> emit) async {
    if (!needToCheckEvent(removedAppointment.clientId)) return;
    bool isRemoved = false;

    _list.removeWhere((ac) {
      final remove = ac.data.appointment.id == removedAppointment.id;

      if (remove) isRemoved = true;
      return remove;
    });

    if (!isRemoved) return;
    emit(ListAppointmentListBlocState(list: _list));
  }

}

class MainAppointmentListBloc extends AppointmentListBloc {
  MainAppointmentListBloc(ScrollTo scrollTo): super(MainAppointmentLoader(), scrollTo);

  @override
  bool needToCheckEvent(int clientId) => true;

}

class SpecialClientAppointmentListBloc extends AppointmentListBloc {

  final int clientId;

  SpecialClientAppointmentListBloc({
    required this.clientId,
    required Client Function() getClient,
    required ScrollTo scrollTo
  }): super(ClientAppointmentLoader(getClient: getClient), scrollTo);

  @override
  bool needToCheckEvent(int clientId) => clientId == this.clientId;

}

typedef ScrollTo = void Function(int position);