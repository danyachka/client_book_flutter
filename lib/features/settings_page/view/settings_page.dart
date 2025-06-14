import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:client_book_flutter/core/widgets/app_clickable/app_button.dart';
import 'package:client_book_flutter/core/widgets/sure_dialog/sure_dialog.dart';
import 'package:client_book_flutter/features/settings_page/viewmodel/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => SettingsCubit(),
        child: Scaffold(
            backgroundColor: AppColors.darkBackground,
            body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: SafeArea(child: _SettingsPageLayout()))));
  }
}

class _SettingsPageLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(S.of(context).settings_title,
              maxLines: 1,
              style: const TextStyle(
                  fontSize: 24,
                  overflow: TextOverflow.ellipsis,
                  fontFamily: AppFont.m,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentText)),
                  
          const SizedBox(height: 24),

          AppTextButton(
              onClick: () {
                showAppAlertDialog(context,
                    text: S.of(context).settings_remove_all,
                    title: S.of(context).settings_remove_all, callBack: () {
                  BlocProvider.of<SettingsCubit>(context).clearDb();
                });
              },
              text: S.of(context).settings_remove_all)
        ]
    );
  }
}
