
import 'package:client_book_flutter/core/model/models/appointment_client.dart';
import 'package:client_book_flutter/core/widgets/app_overlay/app_overlay.dart';
import 'package:client_book_flutter/core/widgets/sure_dialog/sure_dialog.dart';
import 'package:client_book_flutter/core/widgets/text/appointment_text.dart';
import 'package:client_book_flutter/features/appointment_creation/view/appointment_creation_page.dart';
import 'package:client_book_flutter/features/appointment_list/view/appointment_popup.dart';
import 'package:client_book_flutter/features/appointment_list/viewmodel/appointment_list_bloc.dart';
import 'package:client_book_flutter/features/appointment_list/viewmodel/events/appointment_list_bloc_events.dart';
import 'package:client_book_flutter/features/appointment_list/viewmodel/states/appointment_list_bloc_states.dart';
import 'package:client_book_flutter/core/widgets/app_progress/app_progress.dart';
import 'package:client_book_flutter/features/appointment_list/view/appointment_widget.dart';
import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:client_book_flutter/features/client_page/view/client_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class AppointmentListWidget extends StatelessWidget {

  static const _topInfoPadding = 200.0;

  final bool isClientList;

  final FlutterListViewController scrollController;

  const AppointmentListWidget({super.key, required this.scrollController, this.isClientList = false});

  void toClient(BuildContext context, AppointmentClient appointmentClient) {
    if (isClientList) return;

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ClientPage(
        client: appointmentClient.client, 
        onClientUpdatedCallBack: (client) {
          final event = ClientChangedAppointmentListBlocEvent(changedClient: client);
          GetIt.I<MainAppointmentListBloc>().add(event);
        }
      ))
    );
  }

  void toAppointmentEdit(BuildContext context, AppointmentClient appointmentClient) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AppointmentCreationPage(
        initialAppointment: appointmentClient,
        clientAppointmentListBloc: !isClientList? null : BlocProvider.of<SpecialClientAppointmentListBloc>(context)
      ))
    );
  }

  void onRemoveAppointmentClicked(BuildContext context, AppointmentClient appointmentClient) {
    showAppAlertDialog(context, 
      title: S.of(context).appointment_dialog_remove, 
      text: S.of(context).appointment_dialog_remove_text.replaceFirst("%d", appointmentClient.getInfoText()), 
      callBack: () {
        final removeEvent = AppointmentRemovedAppointmentListBlocEvent(removedAppointment: appointmentClient.appointment);

        GetIt.I<MainAppointmentListBloc>().add(removeEvent);
        if (!isClientList) return;

        BlocProvider.of<SpecialClientAppointmentListBloc>(context).add(removeEvent);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppointmentListBloc bloc = isClientList
    ? BlocProvider.of<SpecialClientAppointmentListBloc>(context)
    : GetIt.I<MainAppointmentListBloc>();
    
    return BlocBuilder(
      bloc: bloc,
      builder: (context, state) {
        if (kDebugMode) Logger().i("Rebuilding list with $state");

        if (state is! ListAppointmentListBlocState) {
          return ListView(padding: const EdgeInsets.only(top: _topInfoPadding), children: const [
            Center(child: AppProgressWidget(strokeWidth: 5, size: 40))
          ]);
        }

        if (state.list.isEmpty) {
          return ListView(padding: const EdgeInsets.only(top: 200), children: [
            Center(child: Text(
              S.of(context).nothing_yet,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: AppFont.m,
                fontWeight: FontWeight.bold,
                color: AppColors.accentText
              )
            ))
          ]);
        }

        final nowTime = DateTime.now();

        return FlutterListView(
          controller: scrollController,
          delegate: FlutterListViewDelegate(
            (context, index) {
              final item = state.list[index];

              if (kDebugMode) {
                Logger().i("Building $index, ${DateTime.fromMillisecondsSinceEpoch(item.data.appointment.startTime)}");
              }

              if (index == 0) {
                bloc.add(OldestScrolledAppointmentListBlocEvent(
                  lastAppointmentTime: item.data.appointment.startTime
                ));
              } else if (index == state.list.length - 1) {
                bloc.add(NewestScrolledAppointmentListBlocEvent(
                  newestAppointmentTime: item.data.appointment.startTime
                ));
              }

              final previousItem = index == 0? null: state.list[index - 1].data; 

              final widget = _ItemWidget(
                nowTime: nowTime,
                appointmentClient: item.data,
                previousItem: previousItem,
                toClientCallBack: isClientList? null : toClient,
                editAppointmentCallBack: toAppointmentEdit,
                removeAppointmentCallBack: onRemoveAppointmentClicked,
              );
              if (index != state.list.length - 1) return widget;
              return Padding(padding: const EdgeInsets.only(bottom: 80), child: widget);
            },
            childCount: state.list.length,
            onItemKey: (index) => state.list[index].getKey(),
            keepPosition: true,
            keepPositionOffset: 80
          )
        );
      }
    );
  }
}

class _ItemWidget extends StatefulWidget {
  final DateTime nowTime;
  final AppointmentClient appointmentClient;
  final AppointmentClient? previousItem;

  final ToClientCallBack? toClientCallBack;
  final EditAppointmentCallBack editAppointmentCallBack;
  final RemoveAppointmentCallBack removeAppointmentCallBack;

  const _ItemWidget({
    required this.nowTime,
    required this.appointmentClient,
    required this.previousItem,
    required this.editAppointmentCallBack,
    required this.removeAppointmentCallBack,
    this.toClientCallBack
  });

  @override
  State<_ItemWidget> createState() => __ItemWidgetState();
}

class __ItemWidgetState extends State<_ItemWidget> {


  @override
  Widget build(BuildContext context) {
    return AppointmentWidget(
        onTap: () {
          showAppOverlay(context: context, child: AppointmentPopup(
            appointmentClient: widget.appointmentClient,
            toClientCallBack: widget.toClientCallBack, 
            editAppointmentCallBack: widget.editAppointmentCallBack, 
            removeAppointmentCallBack: widget.removeAppointmentCallBack
          ));
        },
        nowTime: widget.nowTime,
        appointmentClient: widget.appointmentClient,
        previousAppointmentClient: widget.previousItem
    ); 
    
  }
}