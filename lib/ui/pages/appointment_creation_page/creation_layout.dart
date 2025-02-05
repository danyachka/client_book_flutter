

import 'package:client_book_flutter/model/models/appointment_client.dart';
import 'package:client_book_flutter/utils/app_font.dart';
import 'package:client_book_flutter/utils/colors.dart';
import 'package:client_book_flutter/utils/s.dart';
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
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 26),
          ),

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
      )

      // TODO: fields, calendar, time picker, and client picker (via client search)

    ]));
  }
}