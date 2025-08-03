

import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/time_utils.dart';
import 'package:client_book_flutter/core/widgets/app_clickable/clickable.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {

  final Expense expense;
  const ExpenseItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onClick: () {
        // TODO: Open expense edit page
      }, 
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(24)
        ),
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

          Row(children: [
            Expanded(
              child: Text(
                DateTime.fromMillisecondsSinceEpoch(expense.time).getDateText(context),
                style: const TextStyle(
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  fontFamily: AppFont.m,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentTextDarker
                )
              ),
            ),
          ])
        ]),
      )
    );
  }
}