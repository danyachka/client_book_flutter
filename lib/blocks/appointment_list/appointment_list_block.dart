
import 'dart:math';

import 'package:client_book_flutter/blocks/appointment_list/events/appointment_list_block_events.dart';
import 'package:client_book_flutter/blocks/appointment_list/loader/appointment_loaders.dart';
import 'package:client_book_flutter/blocks/appointment_list/states/appointment_list_block_states.dart';
import 'package:client_book_flutter/model/app_database.dart';
import 'package:client_book_flutter/model/daos/appointment_dao.dart';
import 'package:client_book_flutter/model/models/appointment_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


abstract class AppointmentListBlock 
  extends Bloc<AppointmentListBlockEvent, AppointmentListBlockState> {

  static const maxItemsInList = 200;

  final AppointmentLoader _loader;

  final ScrollTo scrollTo;

  List<AppointmentClient> get _list => (state as ListAppointmentListBlockState).list; 
  
  AppointmentListBlock(AppointmentLoader loader, this.scrollTo)
  : _loader = loader, 
    super(LoadingAppointmentListBlockState()) {

    on<ScrollToDateAppointmentListBlockEvent>(
      (event, emit) => _onScrollToEvent(event.time, emit)
    );

    on<OldestScrolledAppointmentListBlockEvent>(
      (event, emit) => _onOldestScrolled(event.lastAppointmentTime, emit)
    );

    on<NewestScrolledAppointmentListBlockEvent>(
      (event, emit) => _onNewestScrolled(event.newestAppointmentTime, emit)
    );

    on<AppointmentChangedAppointmentListBlockEvent>(
      (event, emit) => _onAppointmentChanged(event.changedAppointment, emit)
    );

    on<ClientChangedAppointmentListBlockEvent>(
      (event, emit) => _onClientChanged(event.changedClient, emit)
    );

    on<AppointmentRemovedAppointmentListBlockEvent>(
      (event, emit) => _onAppointmentRemoved(event.removedAppointment, emit)
    );

    onEvent(
      ScrollToDateAppointmentListBlockEvent(time: DateTime.now().millisecondsSinceEpoch)
    );
  }

  bool needToCheckEvent(int clientId);

  void _onScrollToEvent(int time, Emitter<AppointmentListBlockState> emit) async {
    final currentState = state;
    if (currentState is! ListAppointmentListBlockState) return;
    final list = currentState.list;

    if (list.isEmpty) return;

    // in case scroll only
    if (list.first.appointment.startTime <= time && time <= list.last.appointment.startTime) {
      _scrollToTime(time, list);
      return;
    }

    // in case nothing in db
    final centerItem = await _loader.loadNear(time);
    if (centerItem == null) {
      emit(ListAppointmentListBlockState(list: []));
      return;
    }

    // usual case
    int centerItemTime = centerItem.appointment.startTime;
    final lists = await Future.wait([_loader.loadNewer(centerItemTime), _loader.loadOlder(centerItemTime)]);
    
    int centerItemIndex = lists[0].length;
    final itemsList = lists[0]
      ..add(centerItem)
      ..addAll(lists[1]);
    
    emit(ListAppointmentListBlockState(list: itemsList));
    scrollTo(centerItemIndex);
  }

  void _scrollToTime(int time, List<AppointmentClient> list) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].appointment.startTime < time) continue;

      scrollTo(max(0, i - 1));
    }
  }

  void _onNewestScrolled(int time, Emitter<AppointmentListBlockState> emit) async {
    final newItems = await _loader.loadNewer(time);

    if (newItems.isEmpty) return;

    final oldList = _list;

    oldList.addAll(newItems);

    List<AppointmentClient> newList;
    if (oldList.length > maxItemsInList) {
      newList = oldList.sublist(0, AppointmentDao.loadingItemsCount);
    } else {
      newList = _list;
    }

    emit(ListAppointmentListBlockState(list: newList));
  }

  void _onOldestScrolled(int time, Emitter<AppointmentListBlockState> emit) async {
    final newItems = await _loader.loadOlder(time);

    if (newItems.isEmpty) return;

    final oldList = _list;

    oldList.addAll(newItems);

    List<AppointmentClient> newList;
    if (oldList.length > maxItemsInList) {
      newList = oldList.sublist(maxItemsInList - AppointmentDao.loadingItemsCount);
    } else {
      newList = _list;
    }

    emit(ListAppointmentListBlockState(list: newList));
    
  }

  void _onAppointmentChanged(Appointment appointment, Emitter<AppointmentListBlockState> emit) async {
    if (!needToCheckEvent(appointment.clientId)) return;

    final list = _list;
    for (int i = 0; i < list.length; i++) {
      final ac = list[i];

      if (ac.appointment.id != appointment.id) continue;

      list[i] = AppointmentClient(appointment: appointment, client: ac.client);
      emit(ListAppointmentListBlockState(list: list));
      return;
    }
  }

  void _onClientChanged(Client client, Emitter<AppointmentListBlockState> emit) async {
    if (!needToCheckEvent(client.id)) return;
    bool hasChangedAny = false;

    final list = _list;
    for (int i = 0; i < list.length; i++) {
      final ac = list[i];

      if (ac.client.id != client.id) continue;

      list[i] = AppointmentClient(appointment: ac.appointment, client: client);
      hasChangedAny = true;
    }

    if (!hasChangedAny) return;
    emit(ListAppointmentListBlockState(list: list));
  }

  void _onAppointmentRemoved(Appointment removedAppointment, Emitter<AppointmentListBlockState> emit) async {
    if (!needToCheckEvent(removedAppointment.clientId)) return;
    bool isRemoved = false;

    _list.removeWhere((ac) {
      final remove = ac.appointment.id == removedAppointment.id;

      if (remove) isRemoved = true;
      return remove;
    });

    if (!isRemoved) return;
    emit(ListAppointmentListBlockState(list: _list));
  }

}

class MainAppointmentListBlock extends AppointmentListBlock {
  MainAppointmentListBlock(ScrollTo scrollTo): super(MainAppointmentLoader(), scrollTo);

  @override
  bool needToCheckEvent(int clientId) => true;

}

class SpecialClientAppointmentListBlock extends AppointmentListBlock {

  final int clientId;

  SpecialClientAppointmentListBlock({
    required this.clientId,
    required Client Function() getClient,
    required ScrollTo scrollTo
  }): super(ClientAppointmentLoader(getClient: getClient), scrollTo);

  @override
  bool needToCheckEvent(int clientId) => clientId == this.clientId;

}

typedef ScrollTo = void Function(int position);