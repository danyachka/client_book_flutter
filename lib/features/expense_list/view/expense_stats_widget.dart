

import 'dart:math';

import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:client_book_flutter/core/widgets/app_progress/app_progress.dart';
import 'package:client_book_flutter/features/expense_list/viewmodel/expense_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseStatsWidget extends StatelessWidget {
  const ExpenseStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          gradient: LinearGradient(
            colors: [AppColors.primaryDarkTrans, AppColors.grayTrans],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
          )
        ),
        child: BlocBuilder<ExpenseListCubit, ExpenseListState>(builder: (context, state) {
          if (state is LoadingExpenseListState) {
            return const Padding(padding: EdgeInsets.symmetric(vertical: 50), child: Center(child: AppProgressWidget()));
          }

          final readyState = state as ReadyExpenseListState;

          final maxVal = max(readyState.futureValue + readyState.pastValue, readyState.totalExpenses);

          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            if (readyState.futureValue == 0) _Line(
              count: readyState.pastValue, max: maxVal, 
              text: S.of(context).expenses_total_expenses, color: AppColors.primary
            ),

            if (readyState.futureValue != 0) _Line(
              count: readyState.futureValue + readyState.pastValue, max: maxVal, 
              text: S.of(context).expenses_future_value, color: AppColors.primary
            ),
            if (readyState.futureValue != 0) _Line(
              count: readyState.pastValue, max: maxVal, 
              text: S.of(context).expenses_past_value, color: AppColors.orange
            ),

            _Line(
              count: readyState.totalExpenses, max: maxVal, 
              text: S.of(context).expenses_total_expenses, color: AppColors.red
            ),
          ]);
        })
    );
  }
}

class _Line extends StatelessWidget {
  final String text;
  final double count;
  final double max;
  final Color color;

  const _Line({required this.count, required this.max, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    final countInt = (100 * (count/max)).toInt();
    final other = 100 - countInt;

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(text,
          maxLines: 1,
          style: TextStyle(
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
              fontFamily: AppFont.m,
              fontWeight: FontWeight.w600,
              color: color)),

      const SizedBox(height: 8),

      ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: Container(
          height: 32,
          color: AppColors.grayDarker, 
          child: Row(children: [
            Flexible(
              flex: countInt,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16)), 
                  color: color
                )
              )
            ),
            Spacer(flex: other)
          ]
        ))
      )
    ]);
  }
}