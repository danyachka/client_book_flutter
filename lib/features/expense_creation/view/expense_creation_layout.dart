

import 'package:client_book_flutter/core/model/app_database.dart';
import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:client_book_flutter/core/widgets/app_clickable/app_button.dart';
import 'package:client_book_flutter/core/widgets/back_button/app_back_button.dart';
import 'package:client_book_flutter/core/widgets/edit_text/edit_text.dart';
import 'package:client_book_flutter/core/widgets/text/error_text_widget.dart';
import 'package:client_book_flutter/core/widgets/text/hint_text.dart';
import 'package:client_book_flutter/features/calendar/view/date_pick_widget.dart';
import 'package:client_book_flutter/features/expense_creation/viewmodel/expense_creation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ExpenseCreationLayout extends StatefulWidget {
  final Expense? initialExpense;
  const ExpenseCreationLayout({super.key, this.initialExpense});

  @override
  State<ExpenseCreationLayout> createState() => _ExpenseCreationLayoutState();
}

class _ExpenseCreationLayoutState extends State<ExpenseCreationLayout> {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const AppBackButton(),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              (widget.initialExpense == null)
              ? S.of(context).new_expenses
              : S.of(context).edit_expenses,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 20,
                overflow: TextOverflow.ellipsis,
                fontFamily: AppFont.m,
                fontWeight: FontWeight.bold,
                color: AppColors.accentText
              )
            ),
          ),
        ])
      ),

      ExpenseCreationContent(initialExpense: widget.initialExpense)
    ]));
  }
}


class ExpenseCreationContent extends StatefulWidget {
  final Expense? initialExpense;
  const ExpenseCreationContent({super.key, this.initialExpense});

  @override
  State<ExpenseCreationContent> createState() => _ExpenseCreationContentState();
}

class _ExpenseCreationContentState extends State<ExpenseCreationContent> {

  late final TextEditingController textController;
  late final TextEditingController valueController;

  late final ValueNotifier<DateTime> pickedDate;

  @override
  void initState() {
    super.initState();
    final expense = widget.initialExpense;

    textController = TextEditingController(text: expense?.name);
    valueController = TextEditingController(text: expense?.value.toString());

    if (expense == null) {
      pickedDate = ValueNotifier(DateTime.now());
    } else {
      pickedDate = ValueNotifier(DateTime.fromMillisecondsSinceEpoch(expense.time));
    }
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
    valueController.dispose();
    pickedDate.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = ListView(padding: const EdgeInsets.only(top: 16), children: [

      // text
      HintText(text: S.of(context).expenses_text, icon: Icons.assignment_rounded),
      const SizedBox(height: 4),
      BlocBuilder<ExpenseCreationCubit, ExpenseCreationState>(
        buildWhen: (previous, current) => current is CreationExpenseCreationState,
        builder:(context, state) {
          if (state is! CreationExpenseCreationState) return Container();

          if (state.hasCheckedName) return Container();
          return ErrorTextWidget(
            text: S.of(context).required_filed_error
          );
        }
      ),
      const SizedBox(height: 4),
      AppEditTextWidget(
        fontSize: 14,
        controller: textController, 
        hint: S.of(context).appointment_text
      ),

      const SizedBox(height: 12),

      // value
      HintText(text: S.of(context).expenses_value, icon: Icons.attach_money_rounded),
      const SizedBox(height: 4),
      BlocBuilder<ExpenseCreationCubit, ExpenseCreationState>(
        buildWhen: (previous, current) => current is CreationExpenseCreationState,
        builder:(context, state) {
          if (state is! CreationExpenseCreationState) return Container();

          if (state.hasCheckedValue) return Container();
          return ErrorTextWidget(
            text: S.of(context).required_filed_error
          );
        }
      ),
      const SizedBox(height: 4),
      AppEditTextWidget(
        fontSize: 14,
        controller: valueController, 
        hint: S.of(context).appointment_value,
        digitsOnly: true
      ),

      // calendar
      const SizedBox(height: 12),
      DatePickWidget(dateState: pickedDate),

      const SizedBox(height: 12),
      BlocBuilder<ExpenseCreationCubit, ExpenseCreationState>(
        buildWhen: (previous, current) => current is CreationExpenseCreationState,
        builder:(context, state) {
          if (state is! CreationExpenseCreationState) return Container();

          if (!state.hasUnknownError) return Container();
          return ErrorTextWidget(
            text: S.of(context).unknown_error
          );
        }
      ),

      const SizedBox(height: 100)

    ]);

    return Expanded(child: Stack(children: [
      Positioned.fill(child: list),

      Positioned(
        right: 12,
        bottom: 24,
        child: AppButton(
          onClick: () {
            BlocProvider.of<ExpenseCreationCubit>(context).onCreateClicked(
              textController.text, double.tryParse(valueController.text), pickedDate.value
            );
          },
          color: AppColors.primaryDarker,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), 
          child: const Icon(Icons.check_rounded, size: 32, color: AppColors.white)
        )
      )
    ]));
  }
}