

import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/time_utils.dart';
import 'package:client_book_flutter/core/widgets/app_clickable/clickable.dart';
import 'package:client_book_flutter/core/widgets/card_background/card_background.dart';
import 'package:client_book_flutter/features/calendar/view/calendar_widget.dart';
import 'package:flutter/material.dart';

class DatePickWidget extends StatefulWidget {

  final ValueNotifier<DateTime> dateState;

  const DatePickWidget({super.key, required this.dateState});

  @override
  State<DatePickWidget> createState() => _DatePickWidgetState();
}

class _DatePickWidgetState extends State<DatePickWidget> {

  late final ValueNotifier<bool> isCalendarVisible;

  @override
  void initState() {
    super.initState();
    isCalendarVisible = ValueNotifier(true);
  }

  @override
  void dispose() {
    super.dispose();
    isCalendarVisible.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const paddingVertical = 12.0;

    return LargeCardBackground(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(child: ValueListenableBuilder(
              valueListenable: widget.dateState, 
              builder: (context, date, child) {
                return Text(date.getDateText(context),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.accentTextDarker,
                    fontFamily: AppFont.m,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis
                  )
                );
              }
            )),
          
            Clickable(
              onClick: () => isCalendarVisible.value = !isCalendarVisible.value,
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.calendar_month_rounded, 
                  color: AppColors.primaryDark, 
                  size: 24
                )
              )
            )
          ])
        ),

        const SizedBox(height: paddingVertical/2),

        ValueListenableBuilder(
          valueListenable: isCalendarVisible, 
          builder: (context, isVisible, child) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.decelerate,
              switchOutCurve: Curves.decelerate,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: child,
                );
              },
              child: !isVisible? const SizedBox.shrink()
              : Padding(
                padding: const EdgeInsets.only(bottom: paddingVertical/2),
                child: CalendarWidget(
                    withOutBackLayout: true,
                    onDatePicked: (newDate) {
                      widget.dateState.value = newDate;
                      isCalendarVisible.value = false;
                    }
                  ),
              ),
            );
          },
        ),
        
        const SizedBox(height: paddingVertical/2)
      ]),
    );
  }
}