

import 'package:client_book_flutter/blocs/calendar/calendar_state.dart';
import 'package:client_book_flutter/ui/widgets/calendar.dart/calendar_widget.dart';
import 'package:client_book_flutter/utils/app_font.dart';
import 'package:client_book_flutter/utils/colors.dart';
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

    Widget widget;
    if (item.isSelectedDay) {
      widget = Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.primaryLighter
        ),
        child: textWidget 
      );
    } else {
      widget = textWidget;
    }


    return GestureDetector(
      onTap: () => onDatePicked(item.date),
      child: Container(
        padding: EdgeInsets.all(item.isSelectedDay? 1: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: item.sameMonth && !item.isSelectedDay? AppColors.primary: AppColors.primaryDark
        ),
        child: widget
      )
    );
  }
}