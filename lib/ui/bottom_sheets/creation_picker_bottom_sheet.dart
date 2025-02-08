

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
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Center(child: Container(
        width: 40,
        height: 14,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(7)
        )
      )),

      AppLargeButton(
        onTapped: () => Navigator.push(context, MaterialPageRoute(
          builder:(context) => AppointmentCreationPage(mainAppointmentListBloc: mainAppointmentListBloc))), 
        text: S.of(context).create_appointment
      ),
      
      const SizedBox(height: 8),
      
      AppLargeButton(
        onTapped: () => Navigator.push(context, MaterialPageRoute(
          builder:(context) => ClientCreationPage(mainAppointmentListBloc: mainAppointmentListBloc))),
        text: S.of(context).create_client
      )
    ]);
  }
}