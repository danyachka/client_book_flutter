
import 'package:client_book_flutter/blocs/client_creation/client_creation_bloc.dart';
import 'package:client_book_flutter/blocs/client_creation/events/client_creation_event.dart';
import 'package:client_book_flutter/blocs/client_creation/states/client_creation_state.dart';
import 'package:client_book_flutter/model/app_database.dart';
import 'package:client_book_flutter/ui/widgets/edit_text/edit_text.dart';
import 'package:client_book_flutter/ui/widgets/error_text/error_text_widget.dart';
import 'package:client_book_flutter/utils/app_font.dart';
import 'package:client_book_flutter/utils/colors.dart';
import 'package:client_book_flutter/utils/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientCreationLayout extends StatefulWidget {

  final Client? initialClient;
  
  const ClientCreationLayout({super.key, required this.initialClient});

  @override
  State<ClientCreationLayout> createState() => _ClientCreationLayoutState();
}

class _ClientCreationLayoutState extends State<ClientCreationLayout> {

  final nameTextController = TextEditingController();
  final phoneTextController = TextEditingController();


  @override
  void dispose() {
    nameTextController.dispose();
    phoneTextController.dispose();
    super.dispose();
  }

  void _onButtonPressed() {
    BlocProvider.of<ClientCreationBloc>(context).add(
      ClientCreationEvent(
        name: nameTextController.text,
        phone: phoneTextController.text
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: _onButtonPressed, 
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20)
          ),
          child: const Icon(
            Icons.check_rounded, 
            color: AppColors.white,
            size: 26
          )
        )
      ),
      body: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 26),
            ),

            Text(
              (widget.initialClient == null)
              ? S.of(context).new_client
              : S.of(context).edit_client,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 24,
                overflow: TextOverflow.ellipsis,
                fontFamily: AppFont.m,
                fontWeight: FontWeight.w600,
                color: AppColors.accentTextLighter
              )
            ),
          ])
        ),

        ListView(padding: const EdgeInsets.only(top: 8), children: [
          AppEditTextWidget(
            fontSize: 12,
            controller: nameTextController, 
            hint: S.of(context).client_name
          ),

          BlocBuilder<ClientCreationBloc, ClientCreationState>(
            buildWhen: (previous, current) => current is CreationClientCreationState,
            builder:(context, state) {
              if (state is! CreationClientCreationState) return Container();

              if (state.nameError == ClientCreationErrorType.nothing) return Container();
              return ErrorTextWidget(
                text: (state.nameError == ClientCreationErrorType.noInput)? S.of(context).required_filed_error
                      : S.of(context).client_name_error
              );
            }
          ),

          const SizedBox(height: 4),
          
          AppEditTextWidget(
            fontSize: 12,
            controller: nameTextController, 
            hint: S.of(context).client_phone
          ),

          BlocBuilder<ClientCreationBloc, ClientCreationState>(
            buildWhen: (previous, current) => current is CreationClientCreationState,
            builder:(context, state) {
              if (state is! CreationClientCreationState) return Container();

              if (state.phoneError == ClientCreationErrorType.nothing) return Container();
              return ErrorTextWidget(
                text: S.of(context).client_phone_error
              );
            }
          ),

          BlocBuilder<ClientCreationBloc, ClientCreationState>(
            buildWhen: (previous, current) => (current is UnknownErrorClientCreationState || previous is UnknownErrorClientCreationState),
            builder:(context, state) {
              if (state is! UnknownErrorClientCreationState) return Container();

              return ErrorTextWidget(
                text: state.toString()
              );
            }
          ),
        ])
      ]))
    );
  }
}
