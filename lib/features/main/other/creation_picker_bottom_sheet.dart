

import 'package:client_book_flutter/core/widgets/app_clickable/app_button.dart';
import 'package:client_book_flutter/features/appointment_creation/view/appointment_creation_page.dart';
import 'package:client_book_flutter/features/client_creation/view/client_creation_page.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:flutter/material.dart';

class CreationPickerBottomSheet extends StatelessWidget {

  const CreationPickerBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Center(
              child: Container(
                  width: 60,
                  height: 3,
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(7)))),
          const SizedBox(height: 12),
          AppTextButton(
              onClick: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AppointmentCreationPage()));
              },
              text: S.of(context).create_appointment),
          const SizedBox(height: 8),
          AppTextButton(
              onClick: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ClientCreationPage()));
              },
              text: S.of(context).create_client)
        ]);

    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(26), topRight: Radius.circular(26)),
      child: Container(
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
        color: AppColors.darkBackground,
        child: content
      )
    );
  }
}