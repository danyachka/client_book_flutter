
import 'package:client_book_flutter/features/appointment_creation/viewmodel/events/appointment_creation_event.dart';
import 'package:client_book_flutter/features/appointment_creation/viewmodel/states/appointments_creation_states.dart';
import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/model/daos/appointment_dao.dart';
import 'package:client_book_flutter/core/model/models/appointment_client.dart';
import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentCreationBloc 
    extends Bloc<AppointmentCreationEvent, AppointmentCreationState> {

  final int? editAppointmentId;
  final dao = AppointmentDao(AppDatabase());
  
  AppointmentCreationBloc({this.editAppointmentId}) : super(CreationAppointmentCreationState.empty()) {
    on<AppointmentCreationEvent>(_handleEvent);
  }

  void _handleEvent(
    AppointmentCreationEvent event, 
    Emitter<AppointmentCreationState> emit
  ) async {

    emit(LoadingAppointmentCreationState());

    final startTime = event.startTime.millisecondsSinceEpoch;
    final duration = event.duration.inMilliseconds;

    final appointmentsAtTime = await dao.getBetween(startTime, startTime + duration);
    AppointmentCreationTimeError? timeError;
    for (final ac in appointmentsAtTime) {
      if (ac.appointment.id == editAppointmentId) continue;
      timeError = AppointmentCreationTimeError(appointmentAtTime: ac);
      break;
    }

    bool hasNotCheckedClient = event.client == null;
    bool hasNotCheckedValue = event.value == null;
    if (!hasNotCheckedValue) hasNotCheckedValue = event.value! >= 0;
    bool hasNotCheckedText= event.text.isEmpty;

    CreationAppointmentCreationState state = CreationAppointmentCreationState.error(
      timeRangeError: timeError,
      hasNotCheckedClient: hasNotCheckedClient, 
      hasNotCheckedValue: hasNotCheckedValue, 
      hasNotCheckedText: hasNotCheckedText
    );

    // if has errors
    if (!state.isAllFieldsLegal) {
      emit(state);
      return;
    }

    try { // try to insert
      Appointment appointment;
      if (editAppointmentId != null) {
        appointment = await _updateAppointment(event, startTime, duration);
      } else {
        appointment = await _createAppointment(event, startTime, duration);
      }

      emit(DoneAppointmentCreationState(
        createdAC: AppointmentClient(
          appointment: appointment, 
          client: event.client!
        )
      ));
    } catch (e) {
      emit(CreationAppointmentCreationState.unknownError(e.toString()));
    }
    
  }

  Future<Appointment> _createAppointment(
      AppointmentCreationEvent event, int startTime, int duration) async {
    final appointmentCompanion = AppointmentsCompanion.insert(
        id: editAppointmentId == null
            ? const Value.absent()
            : Value(editAppointmentId!),
        clientId: event.client!.id,
        startTime: startTime,
        endTime: startTime + duration,
        notificationStatus: Value(event.status),
        value: Value(event.value!),
        appointmentText: Value(event.text)
    );

    final id = await dao.insertAppointment(appointmentCompanion);

    return Appointment(
        id: id,
        clientId: event.client!.id,
        startTime: startTime,
        endTime: startTime + duration,
        notificationStatus: event.status,
        value: event.value!,
        appointmentText: event.text);
  }

  Future<Appointment> _updateAppointment(
      AppointmentCreationEvent event, int startTime, int duration) async {
    final appointment = Appointment(
        id: editAppointmentId!,
        clientId: event.client!.id,
        startTime: startTime,
        endTime: startTime + duration,
        notificationStatus: event.status,
        value: event.value!,
        appointmentText: event.text
    );

    await dao.updateAppointment(appointment);
    return appointment;
  }
  
}