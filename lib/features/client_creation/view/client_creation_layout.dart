
import 'package:client_book_flutter/core/widgets/app_clickable/app_floating_button.dart';
import 'package:client_book_flutter/core/widgets/back_button/app_back_button.dart';
import 'package:client_book_flutter/core/widgets/text/hint_text.dart';
import 'package:client_book_flutter/features/client_creation/viewmodel/client_creation_bloc.dart';
import 'package:client_book_flutter/features/client_creation/viewmodel/events/client_creation_event.dart';
import 'package:client_book_flutter/features/client_creation/viewmodel/states/client_creation_state.dart';
import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/widgets/edit_text/edit_text.dart';
import 'package:client_book_flutter/core/widgets/text/error_text_widget.dart';
import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientCreationLayout extends StatefulWidget {

  final Client? initialClient;
  
  const ClientCreationLayout({super.key, required this.initialClient});

  @override
  State<ClientCreationLayout> createState() => _ClientCreationLayoutState();
}

class _ClientCreationLayoutState extends State<ClientCreationLayout> {

  late final TextEditingController nameTextController;
  late final TextEditingController phoneTextController;

  @override
  void initState() {
    super.initState();

    nameTextController = TextEditingController(text: widget.initialClient?.name);
    phoneTextController = TextEditingController(text: widget.initialClient?.phoneNumber);
  }

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
      backgroundColor: AppColors.darkBackground,
      floatingActionButton: AppFloatingButton(onClick: _onButtonPressed),
      body: SafeArea(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const AppBackButton(),

            const SizedBox(width: 6),

            Expanded(
              child: Text(
                (widget.initialClient == null)
                ? S.of(context).new_client
                : S.of(context).edit_client,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis,
                  fontFamily: AppFont.m,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentText
                )
              ),
            ),
          ])
        ),

        Expanded(child: ListView(padding: const EdgeInsets.only(top: 16), children: [

          HintText(text: S.of(context).client_name_title, icon: Icons.person_rounded),

          const SizedBox(height: 4),

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
            fontSize: 14,
            controller: nameTextController, 
            hint: S.of(context).client_name
          ),

          const SizedBox(height: 12),

          HintText(text: S.of(context).client_phone_title, icon: Icons.phone_rounded),

          const SizedBox(height: 4),

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

          const SizedBox(height: 4),
          
          AppEditTextWidget(
            fontSize: 14,
            controller: phoneTextController, 
            hint: S.of(context).client_phone,
            digitsOnly: true,
          ),

          const SizedBox(height: 12),

          BlocBuilder<ClientCreationBloc, ClientCreationState>(
            buildWhen: (previous, current) => (current is UnknownErrorClientCreationState || previous is UnknownErrorClientCreationState),
            builder:(context, state) {
              if (state is! UnknownErrorClientCreationState) return Container();

              return ErrorTextWidget(
                text: state.toString()
              );
            }
          ),
        ]))
      ]))
    ));
  }
}
