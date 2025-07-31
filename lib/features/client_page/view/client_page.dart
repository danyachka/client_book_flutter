

import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/features/appointment_list/viewmodel/appointment_list_bloc.dart';
import 'package:client_book_flutter/features/appointment_list/viewmodel/events/appointment_list_bloc_events.dart';
import 'package:client_book_flutter/features/client_page/view/client_page_content.dart';
import 'package:client_book_flutter/features/client_page/viewmodel/client_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientPage extends StatefulWidget {
  final Client client;
  final OnClientUpdated onClientUpdatedCallBack;

  const ClientPage({super.key, required this.client, required this.onClientUpdatedCallBack});

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {

  late final ClientCubit clientCubit;

  @override
  void initState() {
    super.initState();
    clientCubit = ClientCubit(client: widget.client, onClientUpdatedCallBack: widget.onClientUpdatedCallBack);
  }

  @override
  void dispose() {
    super.dispose();
    clientCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider.value(
        value: clientCubit,
      ),
      BlocProvider(
        create: (context) => SpecialClientAppointmentListBloc(
          clientId: widget.client.id, 
          getClient: () => clientCubit.state.client, 
          scrollTo: (pos) => {}
        )
      ),
    ], child: const _ClientPageLayout());
  }
}

class _ClientPageLayout extends StatelessWidget {
  const _ClientPageLayout();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClientCubit, ClientState>(listener: (previous, current) {
        context.read<SpecialClientAppointmentListBloc>().add(
          ClientChangedAppointmentListBlocEvent(changedClient: current.client)
        );
      }, 
      child: const ClientPageContent()
    );
  }
}