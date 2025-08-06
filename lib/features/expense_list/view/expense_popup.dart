

import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:client_book_flutter/core/widgets/app_overlay/app_overlay.dart';
import 'package:client_book_flutter/core/widgets/app_overlay/app_overlay_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpensePopup extends StatelessWidget {
  final Expense expense;
  final void Function(BuildContext context, Expense expense) editExpenseCallBack;
  final void Function(BuildContext context, Expense expense) removeExpenseCallBack;

  const ExpensePopup({super.key, 
    required this.expense,
    required this.editExpenseCallBack,
    required this.removeExpenseCallBack
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppOverlayLine(
            iconData: Icons.edit_rounded, 
            text: S.of(context).edit_expenses, 
            onClick: () { 
              editExpenseCallBack(context, expense);
              context.read<AppOverlayCallBack>().close!();
            }
          ),

          AppOverlayLine(
            iconData: Icons.delete_rounded, 
            text: S.of(context).delete_expenses, 
            onClick: () { 
              removeExpenseCallBack(context, expense);
              context.read<AppOverlayCallBack>().close!();
            }
          )
        ]
    ));
  }
}