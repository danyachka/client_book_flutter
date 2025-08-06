
import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/model/entities_extensions/client_extensions.dart';
import 'package:client_book_flutter/features/appointment_list/view/appointment_list_widget.dart';
import 'package:client_book_flutter/features/client_page/view/client_page_title.dart';
import 'package:client_book_flutter/features/client_page/viewmodel/client_cubit.dart';
import 'package:client_book_flutter/features/main/fragments/list_fragment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_list_view/flutter_list_view.dart';

class ClientPageContent extends StatefulWidget {
  const ClientPageContent({super.key});

  @override
  State<ClientPageContent> createState() => _ClientPageContentState();
}

class _ClientPageContentState extends State<ClientPageContent> {

  late final FlutterListViewController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = FlutterListViewController();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const ClientPageTitle(),

        const _HeaderWidget(),

        Expanded(child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(listCordersRadius), 
            topRight: Radius.circular(listCordersRadius)
          ),
          child: AppointmentListWidget(scrollController: scrollController, isClientList: true),
        ))
      ]))
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientCubit, ClientState>(builder: (context, state) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(state.client.getFormattedPhoneNumber(),
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 24,
                        overflow: TextOverflow.ellipsis,
                        fontFamily: AppFont.m,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentTextLight)),
              ]));
    });
  }
}