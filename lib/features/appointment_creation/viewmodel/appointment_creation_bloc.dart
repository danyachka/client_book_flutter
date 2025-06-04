
import 'package:client_book_flutter/features/appointment_creation/viewmodel/events/appointment_creation_event.dart';
import 'package:client_book_flutter/features/appointment_creation/viewmodel/states/appointments_creation_states.dart';
import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/model/daos/appointment_dao.dart';
import 'package:client_book_flutter/core/model/models/appointment_client.dart';
import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentCreationBloc 
    extends Bloc<AppointmentCreationEvent, AppointmentCreationState> {

  final dao = AppointmentDao(AppDatabase());
  
  AppointmentCreationBloc() : super(CreationAppointmentCreationState.empty()) {
    on<AppointmentCreationEvent>(_handleEvent);
  }

  void _handleEvent(
    AppointmentCreationEvent event, 
    Emitter<AppointmentCreationState> emit
  ) async {

    emit(LoadingAppointmentCreationState());

    final startTime = event.startTime.millisecondsSinceEpoch;
    final duration = event.duration.inMilliseconds;

    final appointmentAtTime = await dao.getBetween(startTime, startTime + duration);
    AppointmentCreationTimeError? timeError = appointmentAtTime == null
    ? null 
    : AppointmentCreationTimeError(appointmentAtTime: appointmentAtTime);

    bool hasNotCheckedClient = event.client == null;
    bool hasNotCheckedValue = event.value == null;
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
      final appointmentCompanion = AppointmentsCompanion.insert(
        clientId: event.client!.id, 
        startTime: startTime, 
        endTime: duration, 
        notificationStatus: Value(event.status), 
        value: Value(event.value!), 
        appointmentText: Value(event.text)
      );

      int id = await dao.insertAppointment(appointmentCompanion);

      final appointment = Appointment(
        id: id, 
        clientId: event.client!.id, 
        startTime: startTime, 
        endTime: duration, 
        notificationStatus: event.status, 
        value: event.value!, 
        appointmentText: event.text
      );

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
  
}