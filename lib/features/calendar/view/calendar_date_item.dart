

import 'package:client_book_flutter/core/widgets/app_clickable/app_button.dart';
import 'package:client_book_flutter/features/calendar/viewmodel/calendar_state.dart';
import 'package:client_book_flutter/features/calendar/view/calendar_widget.dart';
import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:flutter/widgets.dart';

class CalendarDateItem extends StatelessWidget {

  final CalendarItem item;

  final OnDatePicked onDatePicked;

  const CalendarDateItem({super.key, 
    required this.item, 
    required this.onDatePicked
  });

  @override
  Widget build(BuildContext context) {
    Widget textWidget = Center(child: Text(
      item.date.day.toString(),
      style: const TextStyle(              
        fontSize: 12,
        fontFamily: AppFont.m,
        fontWeight: FontWeight.w600,
        color: AppColors.white
      )
    ));

    Widget widget = item.isSelectedDay
    ? Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.primaryLighter
        ),
        child: textWidget 
      )
    : textWidget;

    final color = item.sameMonth && !item.isSelectedDay? AppColors.primary: AppColors.primaryDarker;

    return AppButton(
        onClick: () => onDatePicked(item.date),
        color: color,
        padding: EdgeInsets.zero,
        radius: 12,
        child:  Container(
          padding: EdgeInsets.all(item.isSelectedDay? 1: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: color
          ),
          child: widget
        )
    );
  }
}