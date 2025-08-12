

import 'package:client_book_flutter/core/model/models/appointment_client.dart';
import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:client_book_flutter/core/utils/time_utils.dart';
import 'package:client_book_flutter/core/widgets/app_clickable/clickable.dart';
import 'package:client_book_flutter/core/widgets/card_background/card_background.dart';
import 'package:flutter/material.dart';

class AppointmentWidget extends StatelessWidget {

  final DateTime nowTime;

  final AppointmentClient appointmentClient;
  final AppointmentClient? previousAppointmentClient;
  final void Function() onTap;

  const AppointmentWidget({super.key,
    required this.onTap, 
    required this.nowTime, 
    required this.appointmentClient,
    required this.previousAppointmentClient
  });

  @override
  Widget build(BuildContext context) {

    final date = DateTime.fromMillisecondsSinceEpoch(appointmentClient.appointment.startTime);
    final end = DateTime.fromMillisecondsSinceEpoch(appointmentClient.appointment.endTime);

    String? titleText = getAppointmentText(date, context);

    final widget = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, 
          children: [
            if (titleText != null) Text(
              titleText,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 19,
                overflow: TextOverflow.ellipsis,
                fontFamily: AppFont.m,
                fontWeight: FontWeight.bold,
                color: AppColors.accentText
              )
            ),

            Text(
              "${date.getTodayTimeInDuration().getFormattedTime()} - ${end.getTodayTimeInDuration().getFormattedTime()}",
              maxLines: 1,
              style: const TextStyle(
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
                fontFamily: AppFont.m,
                fontWeight: FontWeight.w600,
                color: AppColors.accentTextLight
              )
            )
          ]
        )
      ),

      CardBackground(
        child: Column(children: [
          Row(children: [
            Expanded(
              child: Text(
                appointmentClient.appointment.appointmentText,
                style: const TextStyle(
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                  fontFamily: AppFont.m,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentTextDarker
                )
              ),
            ),
          ]),
          Row(children: [
            Text(
              appointmentClient.client.name,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 13,
                overflow: TextOverflow.ellipsis,
                fontFamily: AppFont.m,
                fontWeight: FontWeight.bold,
                color: AppColors.accentTextDarker
              )
            ),
            const Spacer(),

            Text(
              appointmentClient.appointment.value.toString(),
              maxLines: 1,
              style: const TextStyle(
                fontSize: 13,
                overflow: TextOverflow.ellipsis,
                fontFamily: AppFont.m,
                fontWeight: FontWeight.w600,
                color: AppColors.accentTextDarker
              )
            ),

            const SizedBox(width: 2),

            const Icon(
              Icons.attach_money_rounded, 
              color: AppColors.accentTextDarker,
              size: 20,
            )

          ])
        ]),
      )
    ]);

    return Clickable(
      onClick: () => onTap(),
      radius: 28,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: widget,
      )
    );
  }

  String? getAppointmentText(DateTime date, BuildContext context) {
    final previousDate = previousAppointmentClient != null
      ? DateTime.fromMillisecondsSinceEpoch(previousAppointmentClient!.appointment.startTime)
      : DateTime.fromMillisecondsSinceEpoch(0);

    if (date.isSameDay(previousDate)) return null;

    if (date.isAfter(nowTime)) {
      if (nowTime.add(const Duration(days: 1)).isSameDay(date)) return S.of(context).tomorrow;
      if (nowTime.add(const Duration(days: 2)).isSameDay(date)) return S.of(context).day_after_tomorrow;
    } else {
      if (nowTime.subtract(const Duration(days: 1)).isSameDay(date)) return S.of(context).yesterday;
      if (nowTime.subtract(const Duration(days: 2)).isSameDay(date)) return S.of(context).day_before_yesterday;
    }

    return "${date.day} ${date.getMonthName(context)}, ${date.getDayShortName(context)}";
  }
}

