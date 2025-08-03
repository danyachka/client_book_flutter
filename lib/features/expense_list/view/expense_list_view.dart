

import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
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
      // TODO: Header to change months

      const ExpenseStatsWidget(),

      const SizedBox(height: 12),

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