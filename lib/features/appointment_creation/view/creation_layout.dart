

import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/model/models/appointment_client.dart';
import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:client_book_flutter/core/widgets/back_button/app_back_button.dart';
import 'package:client_book_flutter/core/widgets/edit_text/edit_text.dart';
import 'package:client_book_flutter/features/appointment_creation/view/client_pick_widget.dart';
import 'package:flutter/material.dart';

class AppointmentCreationLayout extends StatefulWidget {

  final AppointmentClient? initialAC;
  
  const AppointmentCreationLayout({super.key, required this.initialAC});

  @override
  State<AppointmentCreationLayout> createState() => _AppointmentCreationLayoutState();
}

class _AppointmentCreationLayoutState extends State<AppointmentCreationLayout> {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          const AppBackButton(),

          const SizedBox(width: 12),

          Text(
            (widget.initialAC == null)
            ? S.of(context).new_appointment
            : S.of(context).edit_appointment,
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

      const _FieldsLayout()
    ]));
  }
}

class _FieldsLayout extends StatefulWidget {
  const _FieldsLayout();

  @override
  State<_FieldsLayout> createState() => __FieldsLayoutState();
}

class __FieldsLayoutState extends State<_FieldsLayout> {

  late final TextEditingController nameController;
  late final TextEditingController coastController;

  late final ValueNotifier<Client?> pickedClient;
  late final ValueNotifier<int?> pickedDate;

  late final ValueNotifier<TimeOfDay> startTimeState;
  late final ValueNotifier<Duration> durationState;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    coastController = TextEditingController();

    pickedClient = ValueNotifier<Client?>(null);
    pickedDate = ValueNotifier<int?>(null);

    startTimeState = ValueNotifier(const TimeOfDay(hour: 15, minute: 0));
    durationState = ValueNotifier(const Duration(minutes: 60));
  }

  @override
  void dispose() {
    super.dispose();

    nameController.dispose();
    coastController.dispose();
    pickedClient.dispose();
    pickedDate.dispose();
    startTimeState.dispose();
    durationState.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: ListView(padding: const EdgeInsets.only(top: 16), children: [
      AppEditTextWidget(
        fontSize: 14,
        controller: nameController, 
        hint: S.of(context).appointment_text
      ),

      const SizedBox(height: 12),

      AppEditTextWidget(
        fontSize: 14,
        controller: coastController, 
        hint: S.of(context).client_name,
        digitsOnly: true
      ),

      const SizedBox(height: 12),

      SizedBox(height: 60, child: ClientPickWidget(clientState: pickedClient)),

      const SizedBox(height: 16),


    ]));
  }
}