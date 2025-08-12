

import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/model/entities_extensions/client_extensions.dart';
import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:client_book_flutter/core/widgets/app_clickable/app_button.dart';
import 'package:client_book_flutter/features/client_creation/view/client_creation_page.dart';
import 'package:client_book_flutter/features/client_search/view/clients_list_page.dart';
import 'package:flutter/material.dart';

class ClientPickWidget extends StatelessWidget {

  final ValueNotifier<Client?> clientState;

  const ClientPickWidget({super.key, required this.clientState});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _PickedClientWidget(clientState: clientState)),

        const SizedBox(width: 12),

        AspectRatio(
          aspectRatio: 1,
          child: AppButton(
            padding: EdgeInsets.zero,
            onClick: () => _createNewClient(context),
            child: Container(
              alignment: Alignment.center,
              child: const Icon(Icons.add_rounded, size: 20, color: AppColors.primaryDarker)
            )
          )
        )
    ]);
  }

  void _createNewClient(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ClientCreationPage(
        callback: (client) {
          clientState.value = client;
        }
      )
    ));
  }
}

class _PickedClientWidget extends StatelessWidget {

  final ValueNotifier<Client?> clientState;

  const _PickedClientWidget({required this.clientState});

  @override
  Widget build(BuildContext context) {
    final content = ValueListenableBuilder(
      valueListenable: clientState,
      builder: (context, client, child) {
        if (client == null) return const _NoClientWidget();

        return _PickedWidget(client: client);
      },
    );

    return AppButton(
      onClick: () => {
        Navigator.push(context, MaterialPageRoute(
          builder:(context) => ClientsListPage(
            onClientPicked: (client) {
              clientState.value = client; 
            }
          )
        ))
      }, 
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: content
    );
  }
}

class _PickedWidget extends StatelessWidget {

  final Client client;

  const _PickedWidget({required this.client});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(client.name,
          maxLines: 1,
          style: const TextStyle(
              fontSize: 13,
              overflow: TextOverflow.ellipsis,
              fontFamily: AppFont.m,
              fontWeight: FontWeight.bold,
              color: AppColors.accentTextDarker)),

        Text(client.getFormattedPhoneNumber(),
          maxLines: 1,
          style: const TextStyle(
              fontSize: 13,
              overflow: TextOverflow.ellipsis,
              fontFamily: AppFont.m,
              fontWeight: FontWeight.bold,
              color: AppColors.accentTextDarker))
    ]);
  }
}

class _NoClientWidget extends StatelessWidget {

  const _NoClientWidget();

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const Icon(Icons.person_2_rounded, color: AppColors.primaryDarker),

      const SizedBox(width: 12),

      Text(S.of(context).find_client,
          maxLines: 1,
          style: const TextStyle(
              fontSize: 14,
              overflow: TextOverflow.ellipsis,
              fontFamily: AppFont.m,
              fontWeight: FontWeight.bold,
              color: AppColors.accentTextDarker))
    ]);
  }
}