

import 'package:client_book_flutter/core/model/models/appointment_client.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:client_book_flutter/core/widgets/app_overlay/app_overlay.dart';
import 'package:client_book_flutter/core/widgets/app_overlay/app_overlay_line.dart';
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
    return IntrinsicWidth(child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (toClientCallBack != null) AppOverlayLine(
            iconData: Icons.person_rounded, 
            text: S.of(context).appointment_dialog_to_client, 
            onClick: () {
              toClientCallBack!(context, appointmentClient);
              context.read<AppOverlayCallBack>().close!();
            }
          ),
          AppOverlayLine(
            iconData: Icons.edit_rounded, 
            text: S.of(context).appointment_dialog_edit, 
            onClick: () { 
              editAppointmentCallBack(context, appointmentClient);
              context.read<AppOverlayCallBack>().close!();
            }
          ),
          AppOverlayLine(
            iconData: Icons.delete_rounded, 
            text: S.of(context).appointment_dialog_remove, 
            onClick: () { 
              removeAppointmentCallBack(context, appointmentClient);
              context.read<AppOverlayCallBack>().close!();
            }
          )
        ]
    ));
  }
}


typedef ToClientCallBack = void Function(BuildContext context, AppointmentClient appointment);
typedef EditAppointmentCallBack = void Function(BuildContext context, AppointmentClient appointment);
typedef RemoveAppointmentCallBack = void Function(BuildContext context, AppointmentClient appointment);