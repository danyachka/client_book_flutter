
import 'package:client_book_flutter/blocs/appointment_list/appointment_list_bloc.dart';
import 'package:client_book_flutter/blocs/appointment_list/events/appointment_list_bloc_events.dart';
import 'package:client_book_flutter/blocs/client_creation/client_creation_bloc.dart';
import 'package:client_book_flutter/blocs/client_creation/states/client_creation_state.dart';
import 'package:client_book_flutter/blocs/client_search/client_search_bloc.dart';
import 'package:client_book_flutter/blocs/client_search/events/client_search_bloc_events.dart';
import 'package:client_book_flutter/model/app_database.dart';
import 'package:client_book_flutter/ui/pages/client_creation_page/client_creation_layout.dart';
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