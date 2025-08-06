

import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/features/client_page/view/client_page.dart';
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


  final OnClientPickedCallBack? onClientPicked;

  const ClientsListPage({
    super.key, 
    this.onClientPicked
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ClientSearchBloc())
      ], 
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: SafeArea(
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: ClientsSearchTopWidget(),
            ),
          
            Expanded(
              child: BlocBuilder<ClientSearchBloc, ClientSearchBlocState>(
                builder:(context, state) {
                  if (state.list.isEmpty)  {
                    return ListView(children: [
                      Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.only(top: 150),
                        child: Text(
                          S.of(context).nothing_found,
                          style: const TextStyle(
                            fontFamily: AppFont.m,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentText
                          )
                        ),
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
          
                      return ClientItem(client: client, onClick: () {
                        if (onClientPicked != null) {
                          onClientPicked!(client);
                          Navigator.of(context).pop();
                        } else {
                          _startClientPage(context, client);
                        }
                      });
                    },
                  );
                }
              )
            )
          ]),
        ),
      )
    );
  }


  void _startClientPage(BuildContext context, Client client) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (newContext) => ClientPage(
        client: client, 
        onClientUpdatedCallBack: (_) {
          context.read<ClientSearchBloc>().add(
            ClientUpdatedOrAddedClientSearchBlocEvent()
          );
        }
    )));
  }
}


typedef OnClientPickedCallBack = void Function(Client);