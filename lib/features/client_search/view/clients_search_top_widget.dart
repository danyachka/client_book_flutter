

import 'package:client_book_flutter/core/widgets/app_clickable/app_button.dart';
import 'package:client_book_flutter/features/client_search/viewmodel/client_search_bloc.dart';
import 'package:client_book_flutter/features/client_search/viewmodel/client_search_type.dart';
import 'package:client_book_flutter/features/client_search/viewmodel/events/client_search_bloc_events.dart';
import 'package:client_book_flutter/features/client_search/viewmodel/state/client_search_bloc_state.dart';
import 'package:client_book_flutter/core/widgets/edit_text/edit_text.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientsSearchTopWidget extends StatefulWidget {
  const ClientsSearchTopWidget({super.key});

  @override
  State<ClientsSearchTopWidget> createState() => _ClientsSearchTopWidgetState();
}

class _ClientsSearchTopWidgetState extends State<ClientsSearchTopWidget> {

  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      BlocProvider.of<ClientSearchBloc>(context).add(
        NewQueryClientSearchBlocEvent(
          query: controller.text 
        )
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onTypeSwitchPressed(BuildContext context) {
    BlocProvider.of<ClientSearchBloc>(context).add(SearchTypeSwitchedClientSearchBlocEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
          child: BlocListener<ClientSearchBloc, ClientSearchBlocState>(
            listenWhen: (previous, current) => previous.searchType != current.searchType,
            listener: (context, state) => controller.clear(),
            child: BlocBuilder<ClientSearchBloc, ClientSearchBlocState>(
              builder: (context, state) {
                return AppEditTextWidget(
                  fontSize: 12,
                  radius: 80,
                  expands: true,
                  controller: controller,
                  digitsOnly: state.searchType == ClientSearchType.phone,
                  hint: (state.searchType == ClientSearchType.name)
                      ? S.of(context).client_name
                      : S.of(context).client_phone,
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: AppColors.accentText, size: 24),
                );
              }
            ),
          )
        ),
      
        const SizedBox(width: 6),
      
        SizedBox(
          width: 46,
          height: 46,
          child: AppButton(
            onClick: () => onTypeSwitchPressed(context),
            color: AppColors.primary,
            padding: EdgeInsets.zero,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle
              ),
              alignment: Alignment.center,
              child: BlocBuilder<ClientSearchBloc, ClientSearchBlocState>(
                builder:(context, state) => Icon(
                  (state.searchType == ClientSearchType.name)? Icons.person_rounded: Icons.phone_rounded,
                  color: AppColors.darkBackground,
                  size: 24
                )
              )
            )
          ),
        )
      ]),
    );
  }
}