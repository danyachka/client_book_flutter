

import 'package:client_book_flutter/core/model/models/appointment/notification_type.dart';
import 'package:client_book_flutter/core/model/models/appointment_client.dart';
import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:client_book_flutter/core/utils/time_utils.dart';
import 'package:client_book_flutter/core/widgets/app_clickable/clickable.dart';
import 'package:flutter/material.dart';

class AppointmentWidget extends StatelessWidget {

  final DateTime nowTime;

  final AppointmentClient appointmentClient;
  final AppointmentClient? previousAppointmentClient;

  const AppointmentWidget({super.key,
    required this.nowTime, 
    required this.appointmentClient,
    required this.previousAppointmentClient
  });

  void onTap(BuildContext context) {
    // TODO: open dialog
  }

  @override
  Widget build(BuildContext context) {

    final date = DateTime.fromMillisecondsSinceEpoch(appointmentClient.appointment.startTime);

    String? titleText = getAppointmentText(date, context);

    final widget = Column(children: [
      if (titleText != null) Text(
        titleText,
        maxLines: 1,
        style: const TextStyle(
          fontSize: 16,
          overflow: TextOverflow.ellipsis,
          fontFamily: AppFont.m,
          fontWeight: FontWeight.bold,
          color: AppColors.accentText
        )
      ),

      Text(
        date.getTodayTimeInDuration().getFormattedTime(),
        maxLines: 1,
        style: const TextStyle(
          fontSize: 14,
          overflow: TextOverflow.ellipsis,
          fontFamily: AppFont.m,
          fontWeight: FontWeight.w600,
          color: AppColors.accentTextLighter
        )
      ),

      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(children: [
          Row(children: [
            Text(
              appointmentClient.appointment.appointmentText,
              style: const TextStyle(
                fontSize: 12,
                overflow: TextOverflow.ellipsis,
                fontFamily: AppFont.m,
                fontWeight: FontWeight.w600,
                color: AppColors.accentTextDarker
              )
            ),
            const Spacer(),

            Icon(
              (appointmentClient.appointment.notificationStatus == NotificationStatus.enabled)
              ? Icons.notifications_rounded: Icons.notifications_off_rounded, 
              color: AppColors.accentTextDarker
            )
          ]),
          Row(children: [
            Text(
              appointmentClient.client.name,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 12,
                overflow: TextOverflow.ellipsis,
                fontFamily: AppFont.m,
                fontWeight: FontWeight.w600,
                color: AppColors.accentTextDarker
              )
            ),
            const Spacer(),

            Text(
              appointmentClient.appointment.value.toString(),
              maxLines: 1,
              style: const TextStyle(
                fontSize: 12,
                overflow: TextOverflow.ellipsis,
                fontFamily: AppFont.m,
                fontWeight: FontWeight.w600,
                color: AppColors.accentTextDarker
              )
            ),

            const SizedBox(width: 2),

            const Icon(
              Icons.money_rounded, 
              color: AppColors.accentTextDarker
            )

          ])
        ]),
      )
    ]);

    return Clickable(
      onClick: () => onTap(context),
      child: widget,
    );
  }

  String? getAppointmentText(DateTime date, BuildContext context) {
    if (previousAppointmentClient == null) return null;
    
    final previousDate = DateTime.fromMillisecondsSinceEpoch(previousAppointmentClient!.appointment.startTime);

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

