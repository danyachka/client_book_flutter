

import 'package:client_book_flutter/features/appointment_list/viewmodel/appointment_list_bloc.dart';
import 'package:client_book_flutter/features/client_search/viewmodel/client_search_bloc.dart';
import 'package:client_book_flutter/features/client_search/viewmodel/events/client_search_bloc_events.dart';
import 'package:client_book_flutter/features/client_search/viewmodel/state/client_search_bloc_state.dart';
import 'package:client_book_flutter/features/client_search/view/client_item.dart';
import 'package:client_book_flutter/features/client_search/view/clients_search_top_widget.dart';
import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientsListPage extends StatelessWidget {

  final MainAppointmentListBloc mainAppointmentListBloc;

  const ClientsListPage({super.key, required this.mainAppointmentListBloc});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: mainAppointmentListBloc),
        BlocProvider(create: (context) => ClientSearchBloc())
      ], 
      child: Scaffold(
        backgroundColor: AppColors.darkBackground.withAlpha((0.8*255).toInt()),
        body: Column(children: [
          const ClientsSearchTopWidget(),

          Expanded(
            child: BlocBuilder<ClientSearchBloc, ClientSearchBlocState>(
              builder:(context, state) {
                if (state.list.isEmpty)  {
                  return ListView(children: [
                    Text(
                      S.of(context).nothing_found,
                      style: const TextStyle(
                        fontFamily: AppFont.m,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentText
                      )
                    )
                  ]);
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 16, bottom: 40),
                  itemCount: state.list.length,
                  itemBuilder: (context, index) {
                    final client = state.list[index];

                    if (index == state.list.length - 1) {
                      BlocProvider.of<ClientSearchBloc>(context).add(
                        LastScrolledClientSearchBlocEvent(
                          clientId: client.id 
                        )
                      );
                    }

                    return ClientItem(client: client);
                  },
                );
              }
            )
          )
        ]),
      )
    );
  }
}