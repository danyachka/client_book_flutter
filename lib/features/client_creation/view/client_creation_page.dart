
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
import 'package:get_it/get_it.dart';

class ClientCreationPage extends StatefulWidget {

  final Client? initialClient;

  final SpecialClientAppointmentListBloc? clientAppointmentListBloc;
  final ClientSearchBloc? clientSearchBloc;

  final void Function(Client)? callback;

  const ClientCreationPage({super.key, 
    this.clientAppointmentListBloc,
    this.initialClient, 
    this.clientSearchBloc,
    this.callback
  });


  @override
  State<ClientCreationPage> createState() => _ClientCreationPageState();
}

class _ClientCreationPageState extends State<ClientCreationPage> {

  late final ClientCreationBloc clientCreationBloc;

  @override
  void initState() {
    clientCreationBloc = ClientCreationBloc(editClientId: widget.initialClient?.id);
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
    
             GetIt.I<MainAppointmentListBloc>().add(event);
             widget.clientAppointmentListBloc?.add(event);
          }
    
          if (widget.callback != null) widget.callback!(state.createdClient);
    
          Navigator.pop(context); // close page after created 
        },
        child: ClientCreationLayout(initialClient: widget.initialClient)
      )
    );
  }
}