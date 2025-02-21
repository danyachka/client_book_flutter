

import 'package:client_book_flutter/blocs/appointment_creation/appointment_creation_bloc.dart';
import 'package:client_book_flutter/blocs/appointment_creation/states/appointments_creation_states.dart';
import 'package:client_book_flutter/blocs/appointment_list/appointment_list_bloc.dart';
import 'package:client_book_flutter/blocs/appointment_list/events/appointment_list_bloc_events.dart';
import 'package:client_book_flutter/model/models/appointment_client.dart';
import 'package:client_book_flutter/ui/pages/appointment_creation_page/creation_layout.dart';
import 'package:client_book_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentCreationPage extends StatefulWidget {

  final AppointmentClient? initialAppointment;

  final MainAppointmentListBloc mainAppointmentListBloc;
  final SpecialClientAppointmentListBloc? clientAppointmentListBloc;

  const AppointmentCreationPage({super.key, 
    required this.mainAppointmentListBloc, 
    this.clientAppointmentListBloc,
    this.initialAppointment
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
          
          widget.mainAppointmentListBloc.add(event);

          Navigator.pop(context); // close page after created 
        },
        child: Scaffold(
          backgroundColor: AppColors.darkBackground,
          body: SafeArea(child: AppointmentCreationLayout(initialAC: widget.initialAppointment))
        )
      )
    );
  }
}