

import 'dart:math';

import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:client_book_flutter/core/utils/time_utils.dart';
import 'package:client_book_flutter/core/widgets/app_clickable/app_button.dart';
import 'package:client_book_flutter/core/widgets/app_progress/app_progress.dart';
import 'package:client_book_flutter/core/widgets/card_background/card_background.dart';
import 'package:client_book_flutter/features/expense_list/viewmodel/expense_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseStatsWidget extends StatelessWidget {
  const ExpenseStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LargeCardBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ExpenseMonthSwitchTitle(),

            BlocBuilder<ExpenseListCubit, ExpenseListState>(builder: (context, state) {
              if (state is LoadingExpenseListState) {
                return const Padding(padding: EdgeInsets.symmetric(vertical: 50), child: Center(child: AppProgressWidget()));
              }
            
              final readyState = state as ReadyExpenseListState;
            
              final realMaxValue = max(readyState.futureValue + readyState.pastValue, readyState.totalExpenses);
              final maxVal = max(realMaxValue, 1.0);
            
              return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                if (readyState.futureValue == 0) _Line(
                  count: readyState.pastValue, max: maxVal, 
                  text: S.of(context).expenses_total_value, color: AppColors.primary,
                ),
            
                if (readyState.futureValue != 0) _Line(
                  count: readyState.futureValue + readyState.pastValue, max: maxVal, 
                  text: S.of(context).expenses_future_value, color: AppColors.primary,
                ),
                if (readyState.futureValue != 0) _Line(
                  count: readyState.pastValue, max: maxVal, 
                  text: S.of(context).expenses_past_value, color: AppColors.primary,
                ),
            
                _Line(
                  count: readyState.totalExpenses, max: maxVal, 
                  text: S.of(context).expenses_total_expenses, color: AppColors.red,
                ),
              ]);
            }),
          ],
        )
    );
  }
}

class _Line extends StatelessWidget {
  final String text;
  final double count;
  final double max;
  final Color color;

  const _Line({
    required this.count, 
    required this.max, 
    required this.text, 
    required this.color, 
  });

  @override
  Widget build(BuildContext context) {
    final countInt = (100 * (count/max)).toInt();
    final other = 100 - countInt;

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SizedBox(height: 6),

      Text(text.replaceFirst("%d", count.toString()),
          maxLines: 1,
          style: const TextStyle(
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
              fontFamily: AppFont.m,
              fontWeight: FontWeight.w600,
              color: AppColors.accentTextDarker)),

      const SizedBox(height: 8),

      ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Container(
          height: 16,
          color: AppColors.primaryDarker, 
          child: Row(children: [
            if (countInt != 0) Flexible(
              flex: countInt,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)), 
                  color: color
                )
              )
            ),
            if (other != 0) Spacer(flex: other)
          ]
        ))
      )
    ]);
  }
}

class ExpenseMonthSwitchTitle extends StatelessWidget {
  const ExpenseMonthSwitchTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
        _MonthButton(
            onTap: (BuildContext context) {
              final bloc = BlocProvider.of<ExpenseListCubit>(context);
              bloc.goToNewMonth(
                  bloc.state.startMonthTime.getPreviousMonthStart());
            },
            isNext: false),
        const Spacer(),
        BlocBuilder<ExpenseListCubit, ExpenseListState>(
            builder: (context, state) {
          final todayYear = DateTime.now().year;
          bool addYearText = todayYear != state.startMonthTime.year;
      
          return Text(
              "${state.startMonthTime.getMonthName(context)}${(addYearText) ? " ${state.startMonthTime.year % 100}" : ''}",
              style: const TextStyle(
                  fontSize: 20,
                  fontFamily: AppFont.m,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentTextDarker));
        }),
        const Spacer(),
        _MonthButton(
            onTap: (BuildContext context) {
              final bloc = BlocProvider.of<ExpenseListCubit>(context);
              bloc.goToNewMonth(bloc.state.startMonthTime.getNextMonthStart());
            },
            isNext: true),
      ]
    );
  }
}

class _MonthButton extends StatelessWidget {

  final void Function(BuildContext) onTap;

  final bool isNext;

  const _MonthButton({required this.onTap, required this.isNext});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onClick: () => onTap(context),
      color: AppColors.primaryDarker,
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