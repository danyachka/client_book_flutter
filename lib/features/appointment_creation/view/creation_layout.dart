

import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/model/models/appointment/notification_type.dart';
import 'package:client_book_flutter/core/model/models/appointment_client.dart';
import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:client_book_flutter/core/utils/time_utils.dart';
import 'package:client_book_flutter/core/widgets/app_clickable/app_button.dart';
import 'package:client_book_flutter/core/widgets/back_button/app_back_button.dart';
import 'package:client_book_flutter/core/widgets/custom_dialog/app_dialog.dart';
import 'package:client_book_flutter/core/widgets/edit_text/edit_text.dart';
import 'package:client_book_flutter/core/widgets/text/error_text_widget.dart';
import 'package:client_book_flutter/core/widgets/text/hint_text.dart';
import 'package:client_book_flutter/features/appointment_creation/view/client_pick_widget.dart';
import 'package:client_book_flutter/features/appointment_creation/view/date_pick_widget.dart';
import 'package:client_book_flutter/features/appointment_creation/viewmodel/appointment_creation_bloc.dart';
import 'package:client_book_flutter/features/appointment_creation/viewmodel/events/appointment_creation_event.dart';
import 'package:client_book_flutter/features/appointment_creation/viewmodel/states/appointments_creation_states.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

      _FieldsLayout(initialAC: widget.initialAC)
    ]));
  }
}

class _FieldsLayout extends StatefulWidget {

  final AppointmentClient? initialAC;

  const _FieldsLayout({required this.initialAC});

  @override
  State<_FieldsLayout> createState() => __FieldsLayoutState();
}

class __FieldsLayoutState extends State<_FieldsLayout> {

  late final TextEditingController textController;
  late final TextEditingController valueController;

  late final ValueNotifier<Client?> pickedClient;
  late final ValueNotifier<DateTime> pickedDate;

  late final ValueNotifier<TimeOfDay> startTimeState;
  late final ValueNotifier<Duration> durationState;

  @override
  void initState() {
    super.initState();

    final appointment = widget.initialAC?.appointment;
    final client = widget.initialAC?.client;

    textController = TextEditingController(text: appointment?.appointmentText);
    valueController = TextEditingController(text: appointment?.value.toString());

    pickedClient = ValueNotifier(client);

    final startTime = appointment != null? DateTime.fromMillisecondsSinceEpoch(appointment.startTime)
      : DateTime.now().add(const Duration(days: 1));

    pickedDate = ValueNotifier(startTime); // tomorrow as default day

    startTimeState = ValueNotifier(appointment == null
      ? const TimeOfDay(hour: 15, minute: 0)
      : TimeOfDay(hour: startTime.hour, minute: startTime.minute)
    );
    
    durationState = ValueNotifier(appointment == null
      ? const Duration(minutes: 60)
      : Duration(milliseconds: appointment.endTime - appointment.startTime)
    );
  }

  @override
  void dispose() {
    super.dispose();

    textController.dispose();
    valueController.dispose();
    pickedClient.dispose();
    pickedDate.dispose();
    startTimeState.dispose();
    durationState.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = ListView(padding: const EdgeInsets.only(top: 16), children: [

      // text
      HintText(text: S.of(context).appointment_text, icon: Icons.assignment_rounded),
      const SizedBox(height: 4),
      BlocBuilder<AppointmentCreationBloc, AppointmentCreationState>(
        buildWhen: (previous, current) => current is CreationAppointmentCreationState,
        builder:(context, state) {
          if (state is! CreationAppointmentCreationState) return Container();

          if (!state.hasNotCheckedText) return Container();
          return ErrorTextWidget(
            text: S.of(context).required_filed_error
          );
        }
      ),
      const SizedBox(height: 4),
      AppEditTextWidget(
        fontSize: 14,
        controller: textController, 
        hint: S.of(context).appointment_text
      ),

      const SizedBox(height: 12),

      // value
      HintText(text: S.of(context).appointment_value, icon: Icons.attach_money_rounded),
      const SizedBox(height: 4),
      BlocBuilder<AppointmentCreationBloc, AppointmentCreationState>(
        buildWhen: (previous, current) => current is CreationAppointmentCreationState,
        builder:(context, state) {
          if (state is! CreationAppointmentCreationState) return Container();

          if (!state.hasNotCheckedValue) return Container();
          return ErrorTextWidget(
            text: S.of(context).required_filed_error
          );
        }
      ),
      const SizedBox(height: 4),
      AppEditTextWidget(
        fontSize: 14,
        controller: valueController, 
        hint: S.of(context).appointment_value,
        digitsOnly: true
      ),

      // client
      const SizedBox(height: 12),
      BlocBuilder<AppointmentCreationBloc, AppointmentCreationState>(
        buildWhen: (previous, current) => current is CreationAppointmentCreationState,
        builder:(context, state) {
          if (state is! CreationAppointmentCreationState) return Container();

          if (!state.hasNotCheckedClient) return Container();
          return ErrorTextWidget(
            text: S.of(context).required_filed_error
          );
        }
      ),
      const SizedBox(height: 4),
      SizedBox(height: 52, child: ClientPickWidget(clientState: pickedClient)),

      // calendar
      const SizedBox(height: 12),
      DatePickWidget(dateState: pickedDate),

      // start
      const SizedBox(height: 12),
      HintText(text: S.of(context).appointment_start_time),
      const SizedBox(height: 8),
      ValueListenableBuilder(
        valueListenable: startTimeState, 
        builder: (context, time, child) => AppTextButton(
          onClick: _startTimePick, 
          icon: Icons.access_time_rounded,
          text: time.getFormattedTime()
        )
      ),

      // duration
      const SizedBox(height: 12),
      HintText(text: S.of(context).appointment_duration),
      const SizedBox(height: 8),
      ValueListenableBuilder(
        valueListenable: durationState, 
        builder: (context, duration, child) => AppTextButton(
          onClick: _startDurationPick, 
          icon: Icons.access_time_filled_rounded,
          text: duration.getFormattedTime()
        )
      ),

      const SizedBox(height: 12),

      // error
      BlocBuilder<AppointmentCreationBloc, AppointmentCreationState>(
        buildWhen: (previous, current) => current is CreationAppointmentCreationState,
        builder:(context, state) {
          if (state is! CreationAppointmentCreationState) return Container();

          final appointmentAtTime = state.timeRangeError?.appointmentAtTime;
          if (appointmentAtTime != null) {
            final start = DateTime.fromMillisecondsSinceEpoch(appointmentAtTime.appointment.startTime);
            final end = DateTime.fromMillisecondsSinceEpoch(appointmentAtTime.appointment.endTime);
            return ErrorTextWidget(
              text: S.of(context).appointment_with_such_time_error
                .replaceFirst("%c", appointmentAtTime.client.name)
                .replaceFirst("%t", appointmentAtTime.appointment.appointmentText)
                .replaceFirst("%s", start.getFormattedDayTime())
                .replaceFirst("%e", end.getFormattedDayTime())
            );
          }

          if (state.unknownDbError != null) {
            return ErrorTextWidget(
              text: S.of(context).unknown_error
            );
          }

          return Container();
        }
      ),

      const SizedBox(height: 100)

    ]);

    return Expanded(child: Stack(children: [
      Positioned.fill(child: list),

      Positioned(
        right: 12,
        bottom: 24,
        child: AppButton(
          onClick: () {
            final start = pickedDate.value.copyWith(
              hour: startTimeState.value.hour,
              minute: startTimeState.value.minute
            );

            BlocProvider.of<AppointmentCreationBloc>(context).add(AppointmentCreationEvent(
              client: pickedClient.value, 
              startTime: start, 
              duration: durationState.value, 
              status: NotificationStatus.enabled, 
              value: double.tryParse(valueController.text), 
              text: textController.text
            ));
          },
          color: AppColors.primaryDark,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), 
          child: const Icon(Icons.check_rounded, size: 32, color: AppColors.white)
        )
      )
    ]));
  }

  void _startTimePick() async {
    final time = await showTimePicker(
      context: context, 
      initialTime: startTimeState.value 
    );

    if (time != null) startTimeState.value = time;
  }

  void _startDurationPick() {
    showAppDialog(context, 
      title: S.of(context).appointment_start_time, 
      child: ValueListenableBuilder(
        valueListenable: durationState, 
        builder: (context, duration, child) => DurationPicker(
          duration: duration,
          upperBound: const Duration(hours: 12),
          lowerBound: Duration.zero,
          onChange: (duration) => durationState.value = duration
        )
      )
    );
  }
}