
import 'package:client_book_flutter/features/appointment_list/viewmodel/appointment_list_bloc.dart';
import 'package:client_book_flutter/features/appointment_list/viewmodel/events/appointment_list_bloc_events.dart';
import 'package:client_book_flutter/features/client_creation/viewmodel/client_creation_bloc.dart';
import 'package:client_book_flutter/features/client_creation/viewmodel/states/client_creation_state.dart';
import 'package:client_book_flutter/features/client_search/viewmodel/client_search_bloc.dart';
import 'package:client_book_flutter/features/client_search/viewmodel/events/client_search_bloc_events.dart';
import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/features/client_creation/view/client_creation_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientCreationPage extends StatefulWidget {

  final Client? initialClient;

  final MainAppointmentListBloc mainAppointmentListBloc;
  final SpecialClientAppointmentListBloc? clientAppointmentListBloc;
  final ClientSearchBloc? clientSearchBloc;

  const ClientCreationPage({super.key, 
    required this.mainAppointmentListBloc, 
    this.clientAppointmentListBloc,
    this.initialClient, 
    this.clientSearchBloc
  });


  @override
  State<ClientCreationPage> createState() => _ClientCreationPageState();
}

class _ClientCreationPageState extends State<ClientCreationPage> {

  late final ClientCreationBloc clientCreationBloc;

  @override
  void initState() {
    clientCreationBloc = ClientCreationBloc();
    super.initState();
  }

  @override
  void dispose() {
    clientCreationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: clientCreationBloc,
      child: BlocListener(
        bloc: clientCreationBloc,
        listener:(context, ClientCreationState state) {
          if (state is! DoneClientCreationState) return;

          widget.clientSearchBloc?.add(ClientUpdatedOrAddedClientSearchBlocEvent());
          if (widget.initialClient != null) { // if client update
             final event = ClientChangedAppointmentListBlocEvent(changedClient: state.createdClient);

             widget.mainAppointmentListBloc.add(event);
             widget.clientAppointmentListBloc?.add(event);
          }

          Navigator.pop(context); // close page after created 
        },
        child: ClientCreationLayout(initialClient: widget.initialClient)
      )
    );
  }
}