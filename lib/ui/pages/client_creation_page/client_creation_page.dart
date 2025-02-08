
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

class ClientCreationPage extends StatelessWidget {

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
  Widget build(BuildContext context) {
    return BlocProvider(
      create:(context) => ClientCreationBloc(),
      lazy: false,
      child: BlocListener(
        bloc: BlocProvider.of<ClientCreationBloc>(context),
        listener:(context, ClientCreationState state) {
          if (state is! DoneClientCreationState) return;

          clientSearchBloc?.add(ClientUpdatedOrAddedClientSearchBlocEvent());
          if (initialClient != null) { // if client update
             final event = ClientChangedAppointmentListBlocEvent(changedClient: state.createdClient);

             mainAppointmentListBloc.add(event);
             clientAppointmentListBloc?.add(event);
          }

          Navigator.pop(context); // close page after created 
        },
        child: ClientCreationLayout(initialClient: initialClient)
      )
    );
  }
}