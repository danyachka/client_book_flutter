

import 'package:client_book_flutter/core/model/models/appointment_client.dart';
import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:client_book_flutter/core/widgets/app_clickable/clickable.dart';
import 'package:client_book_flutter/core/widgets/app_overlay/app_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentPopup extends StatelessWidget {
  final AppointmentClient appointmentClient;

  final ToClientCallBack? toClientCallBack;
  final EditAppointmentCallBack editAppointmentCallBack;
  final RemoveAppointmentCallBack removeAppointmentCallBack;

  const AppointmentPopup({super.key, 
    required this.appointmentClient,
    this.toClientCallBack,
    required this.editAppointmentCallBack,
    required this.removeAppointmentCallBack
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (toClientCallBack != null) _Line(
            iconData: Icons.person_rounded, 
            text: S.of(context).appointment_dialog_to_client, 
            onClick: () {
              toClientCallBack!(context, appointmentClient);
              context.read<AppOverlayCallBack>().close!();
            }
          ),
          _Line(
            iconData: Icons.edit_rounded, 
            text: S.of(context).appointment_dialog_edit, 
            onClick: () { 
              editAppointmentCallBack(context, appointmentClient);
              context.read<AppOverlayCallBack>().close!();
            }
          ),
          _Line(
            iconData: Icons.delete_rounded, 
            text: S.of(context).appointment_dialog_remove, 
            onClick: () { 
              removeAppointmentCallBack(context, appointmentClient);
              context.read<AppOverlayCallBack>().close!();
            }
          )
        ]
    );
  }
}

class _Line extends StatelessWidget {
  final String text;
  final IconData iconData;
  final void Function() onClick;
  
  const _Line({required this.iconData, required this.text, required this.onClick});

  @override
  Widget build(BuildContext context) {
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(iconData, size: 24, color: AppColors.accentTextLighter),

        const SizedBox(width: 12),

        Text(
          text,
          maxLines: 1,
          style: const TextStyle(
                  fontSize: 12,
                  overflow: TextOverflow.ellipsis,
                  fontFamily: AppFont.m,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentTextLighter)
        )
      ]
    );

    return Clickable(onClick: onClick, child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: row
    ));
  }
}

typedef ToClientCallBack = void Function(BuildContext context, AppointmentClient appointment);
typedef EditAppointmentCallBack = void Function(BuildContext context, AppointmentClient appointment);
typedef RemoveAppointmentCallBack = void Function(BuildContext context, AppointmentClient appointment);