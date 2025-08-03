

import 'package:client_book_flutter/core/widgets/app_clickable/app_button.dart';
import 'package:client_book_flutter/features/calendar/viewmodel/calendar_cubit.dart';
import 'package:client_book_flutter/features/calendar/viewmodel/calendar_state.dart';
import 'package:client_book_flutter/features/calendar/view/calendar_date_item.dart';
import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/time_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarWidget extends StatelessWidget {

  final OnDatePicked onDatePicked;

  final bool withOutBackLayout;

  const CalendarWidget({super.key, this.withOutBackLayout = false, required this.onDatePicked});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:(context) => CalendarCubit(DateTime.now()),
      lazy: false,
      child: Container(
        padding: withOutBackLayout? null : const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: withOutBackLayout? null : BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(16)
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            _MonthButton(
              onTap: (BuildContext context) => BlocProvider.of<CalendarCubit>(context).goToPreviousMonth(),
              isNext: false
            ),

            const Spacer(),

            BlocBuilder<CalendarCubit, CalendarState>(
              builder: (context, state) {

                final todayYear = DateTime.now().year;
                bool addYearText = todayYear != state.mouth.year;

                return Text(
                  "${state.mouth.getMonthName(context)}${(addYearText)? " ${state.mouth.year % 100}": ''}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: AppFont.m,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentTextDarker
                  )
                );
              }
            ),

            const Spacer(),
            _MonthButton(
              onTap: (BuildContext context) => BlocProvider.of<CalendarCubit>(context).goToNextMonth(),
              isNext: true
            ),
          ]),

          const SizedBox(height: 6),

          Row(
            mainAxisSize: MainAxisSize.max,
            children: List.generate(7, (day) => Expanded(child: Center(child: Text(
                getDayShortNameByNumber(context, day + 1),
                style: const TextStyle(              
                  fontSize: 13,
                  fontFamily: AppFont.m,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentTextDarker
                )
              )
            )))
          ),

          const SizedBox(height: 6),

          AnimatedSize(
            alignment: Alignment.topCenter,
            curve: Curves.decelerate,
            duration: const Duration(milliseconds: 300),
            child: BlocBuilder<CalendarCubit, CalendarState>(
              builder: (context, state) {
                final weeksCount = (state.list.length / 7).ceil(); 
                return Column(spacing: 3, mainAxisSize: MainAxisSize.min, children: List.generate(
                  weeksCount, 
                  (week) => Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 5,
                    children: List.generate(7, (day) => Expanded(child: CalendarDateItem(
                      item: state.list[week*7 + day], 
                      onDatePicked: onDatePicked
                    )))
                  )
                ));
              }
            )
          )
        ])
      )
    );
  }
}

typedef OnDatePicked = void Function(DateTime pickedDate);

class _MonthButton extends StatelessWidget {

  final void Function(BuildContext) onTap;

  final bool isNext;

  const _MonthButton({required this.onTap, required this.isNext});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onClick: () => onTap(context),
      color: AppColors.primaryDark,
      padding: EdgeInsets.zero,
      radius: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
        ),
        child: Icon(isNext? Icons.arrow_forward_rounded: Icons.arrow_back_rounded, 
          color: AppColors.white,
          size: 16
        )
      )
    );
  }
}