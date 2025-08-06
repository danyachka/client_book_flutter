

import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:client_book_flutter/core/utils/time_utils.dart';
import 'package:client_book_flutter/core/widgets/app_clickable/clickable.dart';
import 'package:client_book_flutter/core/widgets/app_overlay/app_overlay.dart';
import 'package:client_book_flutter/core/widgets/card_background/card_background.dart';
import 'package:client_book_flutter/core/widgets/sure_dialog/sure_dialog.dart';
import 'package:client_book_flutter/features/expense_creation/view/expense_creation_page.dart';
import 'package:client_book_flutter/features/expense_list/view/expense_popup.dart';
import 'package:client_book_flutter/features/expense_list/viewmodel/expense_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseItem extends StatelessWidget {

  final Expense expense;
  const ExpenseItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
              DateTime.fromMillisecondsSinceEpoch(expense.time).getDateText(context),
              maxLines: 1,
              style: const TextStyle(
                  fontSize: 18,
                  overflow: TextOverflow.ellipsis,
                  fontFamily: AppFont.m,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentText
              )
          )
        ),


        CardBackground(
          child: Column(children: [
            Row(children: [
              Text(
                expense.value.toString(),
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                  fontFamily: AppFont.m,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentTextDarker
                )
              ),

              const SizedBox(width: 2),

              const Icon(
                Icons.attach_money_rounded, 
                color: AppColors.accentTextDarker,
                size: 24,
              )
            ]),

            Row(children: [
              Expanded(
                child: Text(
                  expense.name,
                  style: const TextStyle(
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: AppFont.m,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentTextDarker
                  )
                ),
              ),
            ]),
          ]),
        )
      ],
    );


    return Clickable(
      onClick: () {
        final bloc = context.read<ExpenseListCubit>();
        showAppOverlay(context: context, child: ExpensePopup(
          expense: expense, 
          editExpenseCallBack: (overlayContext, expense) {
            Navigator.of(overlayContext).push(MaterialPageRoute(
              builder: (context) => ExpenseCreationPage(
                callback: (expense) => bloc.onListUpdate(),
                initialExpense: expense,
              )
            ));
          },
          removeExpenseCallBack: (overlayContext, expense) {
            showAppAlertDialog(context, 
              title: S.of(context).appointment_dialog_remove, 
              text: S.of(context).appointment_dialog_remove_text.replaceFirst("%d", expense.name), 
              callBack: () {
                bloc.onExpenseRemove(expense);
              }
            );
          },
        ));
      }, 
      radius: 28,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: column
      )
    );
  }
}