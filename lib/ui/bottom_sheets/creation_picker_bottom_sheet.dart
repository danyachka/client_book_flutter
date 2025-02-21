

import 'package:client_book_flutter/blocs/appointment_list/appointment_list_bloc.dart';
import 'package:client_book_flutter/ui/pages/appointment_creation_page/appointment_creation_page.dart';
import 'package:client_book_flutter/ui/pages/client_creation_page/client_creation_page.dart';
import 'package:client_book_flutter/ui/widgets/app_large_button/app_large_button.dart';
import 'package:client_book_flutter/utils/colors.dart';
import 'package:client_book_flutter/utils/s.dart';
import 'package:flutter/material.dart';

class CreationPickerBottomSheet extends StatelessWidget {

  final MainAppointmentListBloc mainAppointmentListBloc;

  const CreationPickerBottomSheet({super.key, required this.mainAppointmentListBloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(26), topRight: Radius.circular(26)),
        color: AppColors.darkBackground
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 16),

        Center(child: Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(7)
          )
        )),

        const SizedBox(height: 12),

        AppLargeButton(
          onTapped: () {
            Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(
              builder:(context) => AppointmentCreationPage(mainAppointmentListBloc: mainAppointmentListBloc)));
          } ,
          text: S.of(context).create_appointment
        ),
        
        const SizedBox(height: 8),
        
        AppLargeButton(
          onTapped: () {
            Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(
              builder:(context) => ClientCreationPage(mainAppointmentListBloc: mainAppointmentListBloc)));
          },
          text: S.of(context).create_client
        )
      ])
    );
  }
}