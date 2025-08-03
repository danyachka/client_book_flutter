

import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:client_book_flutter/core/utils/time_utils.dart';
import 'package:client_book_flutter/core/widgets/app_clickable/app_button.dart';
import 'package:client_book_flutter/core/widgets/app_clickable/clickable.dart';
import 'package:client_book_flutter/core/widgets/app_progress/app_progress.dart';
import 'package:client_book_flutter/features/expense_list/view/expense_item.dart';
import 'package:client_book_flutter/features/expense_list/view/expense_stats_widget.dart';
import 'package:client_book_flutter/features/expense_list/viewmodel/expense_list_cubit.dart';
import 'package:client_book_flutter/features/main/fragments/list_fragment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseListView extends StatelessWidget {
  const ExpenseListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(children: [
          Expanded(child: Text(
              S.of(context).stats_title,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: AppFont.m,
                fontWeight: FontWeight.bold,
                color: AppColors.accentText
              )
          )),

           Clickable(
              onClick: () {
                final bloc = context.read<ExpenseListCubit>().state;

                // TODO: Start expense creation page
              },
              rippleColor: AppColors.primaryDark,
              radius: 32,
              child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.add_rounded,
                      color: AppColors.primary, size: 26)))
        ]),
      ),
      const SizedBox(height: 12),

      const ExpenseMonthSwitchTitle(),
      const SizedBox(height: 12),

      const AnimatedSize(
        duration: Duration(milliseconds: 200),
        alignment: Alignment.topCenter,
        child: ExpenseStatsWidget()
      ),
      const SizedBox(height: 12),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(children: [
          Expanded(child: Text(
              S.of(context).expenses_title,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: AppFont.m,
                fontWeight: FontWeight.bold,
                color: AppColors.accentText
              )
            ))
        ]),
      ),
      const SizedBox(height: 4),

      Expanded(
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(listCordersRadius)),
          child: BlocBuilder<ExpenseListCubit, ExpenseListState>(
            builder: (context, state) {
              if (state is LoadingExpenseListState) {
                return ListView(padding: const EdgeInsets.symmetric(vertical: 100), children: const [Center(child: AppProgressWidget())]);
              } 
              final readyState = state as ReadyExpenseListState;
          
              if (readyState.expenses.isEmpty) {
                return ListView(padding: const EdgeInsets.symmetric(vertical: 100), children: [
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
          
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: readyState.expenses.length,
                itemBuilder: (context, index) {
                  final expense = readyState.expenses[index];
          
                  return ExpenseItem(expense: expense); 
                }
              );
            }),
        ),
      )
    ]);
  }
}

class ExpenseMonthSwitchTitle extends StatelessWidget {
  const ExpenseMonthSwitchTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(children: [
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
      ]),
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
      color: AppColors.primaryDark,
      padding: EdgeInsets.zero,
      radius: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16)
        ),
        child: Icon(isNext? Icons.arrow_forward_rounded: Icons.arrow_back_rounded, 
          color: AppColors.white,
          size: 24
        )
      )
    );
  }
}