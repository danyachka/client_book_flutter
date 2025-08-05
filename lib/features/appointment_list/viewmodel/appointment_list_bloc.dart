
import 'dart:math';

import 'package:client_book_flutter/features/appointment_list/viewmodel/entity.dart';
import 'package:client_book_flutter/features/appointment_list/viewmodel/events/appointment_list_bloc_events.dart';
import 'package:client_book_flutter/features/appointment_list/model/appointment_loaders.dart';
import 'package:client_book_flutter/features/appointment_list/viewmodel/states/appointment_list_bloc_states.dart';
import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/model/daos/appointment_dao.dart';
import 'package:client_book_flutter/core/model/models/appointment_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';


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
      (event, emit) => _onScrollToEvent(event.time, event.animate, emit)
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

    on<AppointmentAddedAppointmentListBlocEvent>(
      (event, emit) => _onAppointmentAdded(event.newAppointment, emit)
    );

    on<ClientChangedAppointmentListBlocEvent>(
      (event, emit) => _onClientChanged(event.changedClient, emit)
    );

    on<AppointmentRemovedAppointmentListBlocEvent>(
      (event, emit) => _onAppointmentRemoved(event.removedAppointment, emit)
    );

    add(
      ScrollToDateAppointmentListBlocEvent(time: DateTime.now().millisecondsSinceEpoch, animate: false)
    );
  }

  bool needToCheckEvent(int clientId);

  void _onScrollToEvent(int time, bool animate, Emitter<AppointmentListBlocState> emit) async {
    final currentState = state;
    
    // in case scroll only
    if (currentState is ListAppointmentListBlocState) {
      final list = currentState.list;
      if (list.isNotEmpty) {
        if (list.first.data.appointment.startTime <= time && time <= list.last.data.appointment.startTime) {
          _scrollToTime(time, list, animate);
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

    if (kDebugMode) {
      Logger().i("center item ${DateTime.fromMillisecondsSinceEpoch(centerItem.appointment.startTime)}");
    }

    // usual case
    int centerItemTime = centerItem.appointment.startTime;
    final [newer, older] = await Future.wait([_loader.loadNewer(centerItemTime), _loader.loadOlder(centerItemTime)]);
    
    final itemsList = older.reversed.toList();
    itemsList.add(centerItem);
    itemsList.addAll(newer);
    
    emit(ListAppointmentListBlocState(
      list: itemsList.map((e) => AppointmentListItem(data: e)).toList()
    ));
    
    int centerItemIndex = older.length;
    await Future.delayed(const Duration(milliseconds: 200));
    _scrollTo(centerItemIndex, animate);

    if (kDebugMode) {
      Logger().i("Scrolling to centerItemIndex $centerItemIndex, older = ${older.length}, newer = ${newer.length}");
    }
  }

  void _scrollToTime(int time, List<AppointmentListItem> list, bool animate) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].data.appointment.startTime < time) continue;

      _scrollTo(max(0, i - 1), animate);
      break;
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
      newList = oldList.sublist(AppointmentDao.loadingItemsCount);
    } else {
      newList = _list;
    }

    emit(ListAppointmentListBlocState(list: newList));
  }

  void _onOldestScrolled(int time, Emitter<AppointmentListBlocState> emit) async {
    final newData = await _loader.loadOlder(time);

    if (newData.isEmpty) return;
    final newItems = newData.map((e) => AppointmentListItem(data: e)).toList().reversed;

    final oldList = _list;

    oldList.insertAll(0, newItems);

    List<AppointmentListItem> newList;
    if (oldList.length > maxItemsInList) {
      newList = oldList.sublist(0, maxItemsInList - AppointmentDao.loadingItemsCount);
    } else {
      newList = oldList;
    }

    emit(ListAppointmentListBlocState(list: newList));
    
  }

  void _onAppointmentAdded(AppointmentClient ac, Emitter<AppointmentListBlocState> emit) async {
    final appointment = ac.appointment;
    if (!needToCheckEvent(appointment.clientId)) return;

    final list = _list;
    if (_list.length > AppointmentDao.loadingItemsCount) {
      if (ac.appointment.startTime < list.first.data.appointment.startTime
          || list.last.data.appointment.startTime < ac.appointment.startTime) {
        return;
      }
    }

    if (list.isEmpty) {
      list.add(AppointmentListItem(data: ac));
    } else {
      bool isInserted = false;
      for (int i = 0; i < list.length; i++) {
        if (ac.appointment.startTime > list[i].data.appointment.startTime) continue;
        list.insert(i, AppointmentListItem(data: ac));
        isInserted = true;
        break;
      }

      if (!isInserted) list.add(AppointmentListItem(data: ac)); // in case last one
    }

    emit(ListAppointmentListBlocState(list: list));
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

typedef ScrollTo = void Function(int position, bool animate);