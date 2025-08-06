

import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/features/expense_creation/view/expense_creation_layout.dart';
import 'package:client_book_flutter/features/expense_creation/viewmodel/expense_creation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseCreationPage extends StatefulWidget {
  final Expense? initialExpense;
  final void Function(Expense expense)? callback;
  const ExpenseCreationPage({super.key, this.callback, this.initialExpense});

  @override
  State<ExpenseCreationPage> createState() => _ExpenseCreationPageState();
}

class _ExpenseCreationPageState extends State<ExpenseCreationPage> {

  late final ExpenseCreationCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = ExpenseCreationCubit(editExpenseId: widget.initialExpense?.id);
  }

  @override
  void dispose() {
    super.dispose();
    cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocListener(
        bloc: cubit,
        listener: (context, ExpenseCreationState state) {
          if (state is! DoneExpenseCreationState) return;

          if (widget.callback != null) widget.callback!(state.expense);

          Navigator.pop(context); // close page after created 
        },
        child: Scaffold(
          backgroundColor: AppColors.darkBackground,
          body: SafeArea(
            child: ExpenseCreationLayout(
              initialExpense: widget.initialExpense
            ),
          )
        )
      )
    );
  }
}