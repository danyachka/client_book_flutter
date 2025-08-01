

import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/features/appointment_creation/viewmodel/appointment_creation_bloc.dart';
import 'package:client_book_flutter/features/appointment_creation/viewmodel/states/appointments_creation_states.dart';
import 'package:client_book_flutter/features/appointment_list/viewmodel/appointment_list_bloc.dart';
import 'package:client_book_flutter/features/appointment_list/viewmodel/events/appointment_list_bloc_events.dart';
import 'package:client_book_flutter/core/model/models/appointment_client.dart';
import 'package:client_book_flutter/features/appointment_creation/view/creation_layout.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AppointmentCreationPage extends StatefulWidget {

  final AppointmentClient? initialAppointment;
  final Client? initialClient;
  final void Function(AppointmentClient)? callback;

  final SpecialClientAppointmentListBloc? clientAppointmentListBloc;

  const AppointmentCreationPage({super.key, 
    this.clientAppointmentListBloc,
    this.initialAppointment, 
    this.initialClient, 
    this.callback
  });

  @override
  State<AppointmentCreationPage> createState() => _AppointmentCreationPageState();
}

class _AppointmentCreationPageState extends State<AppointmentCreationPage> {

  late final AppointmentCreationBloc appointmentCreationBloc;

  @override
  void initState() {
    appointmentCreationBloc = AppointmentCreationBloc();
    super.initState();
  }

  @override
  void dispose() {
    appointmentCreationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: appointmentCreationBloc,
      child: BlocListener(
        bloc: appointmentCreationBloc,
        listener: (context, AppointmentCreationState state) {
          if (state is! DoneAppointmentCreationState) return;

          final event = (widget.initialAppointment != null)
          ? AppointmentChangedAppointmentListBlocEvent(changedAppointment: state.createdAC.appointment)
          : AppointmentAddedAppointmentListBlocEvent(newAppointment: state.createdAC); 
          
          GetIt.I<MainAppointmentListBloc>().add(event);
          widget.clientAppointmentListBloc?.add(event);

          if (widget.callback != null) widget.callback!(state.createdAC);

          Navigator.pop(context); // close page after created 
        },
        child: Scaffold(
          backgroundColor: AppColors.darkBackground,
          body: SafeArea(child: AppointmentCreationLayout(
            initialAC: widget.initialAppointment, 
            initialClient: widget.initialClient
          ))
        )
      )
    );
  }
}