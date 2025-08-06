import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/widgets/app_clickable/clickable.dart';
import 'package:client_book_flutter/core/widgets/back_button/app_back_button.dart';
import 'package:client_book_flutter/features/appointment_creation/view/appointment_creation_page.dart';
import 'package:client_book_flutter/features/appointment_list/viewmodel/appointment_list_bloc.dart';
import 'package:client_book_flutter/features/client_creation/view/client_creation_page.dart';
import 'package:client_book_flutter/features/client_page/viewmodel/client_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientPageTitle extends StatelessWidget {
  const ClientPageTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const AppBackButton(),
          const SizedBox(width: 6),
          Expanded(
            child: BlocBuilder<ClientCubit, ClientState>(
                builder: (context, state) {
              return Text(state.client.name,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 20,
                      overflow: TextOverflow.ellipsis,
                      fontFamily: AppFont.m,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentTextLight));
            }),
          ),
          const SizedBox(width: 6),
          Clickable(
              onClick: () {
                final client = context.read<ClientCubit>().state.client;
                final listBloc = context.read<SpecialClientAppointmentListBloc>();

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AppointmentCreationPage(
                        initialClient: client,
                        clientAppointmentListBloc: listBloc,
                        callback: (createdAC) {
                          // TODO: Update appointments count
                        })));
              },
              radius: 32,
              child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.add_rounded,
                      color: AppColors.primary, size: 26))),
          Clickable(
              onClick: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (newContext) => ClientCreationPage(
                        initialClient: context.read<ClientCubit>().state.client,
                        callback: (updatedClient) {
                          context.read<ClientCubit>()
                              .onClientUpdated(updatedClient);
                        })));
              },
              radius: 32,
              child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.edit_rounded,
                      color: AppColors.primary, size: 26)))
        ]));
  }
}
