import 'package:client_book_flutter/core/utils/app_font.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:client_book_flutter/core/widgets/app_clickable/app_button.dart';
import 'package:client_book_flutter/core/widgets/back_button/app_back_button.dart';
import 'package:client_book_flutter/core/widgets/edit_text/edit_text.dart';
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
        child: const Scaffold(
            backgroundColor: AppColors.darkBackground,
            body: Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                child: SafeArea(child: _SettingsPageLayout()))));
  }
}

class _SettingsPageLayout extends StatefulWidget {
  const _SettingsPageLayout();

  @override
  State<_SettingsPageLayout> createState() => __SettingsPageLayoutState();
}

class __SettingsPageLayoutState extends State<_SettingsPageLayout> {

  late final TextEditingController dbEditText;

  @override
  void initState() {
    super.initState();
    dbEditText = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    dbEditText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AppBackButton(),

              const SizedBox(width: 8),

              Text(S.of(context).settings_title,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 20,
                      overflow: TextOverflow.ellipsis,
                      fontFamily: AppFont.m,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentText)),
            ],
          ),
                  
          const SizedBox(height: 8),

          AppTextButton(
              onClick: () {
                showAppAlertDialog(context,
                    text: S.of(context).settings_remove_all,
                    title: S.of(context).settings_remove_all, 
                    isNoLighted: true,
                    callBack: () {
                      BlocProvider.of<SettingsCubit>(context).clearDb();
                    }
                );
              },
              text: S.of(context).settings_remove_all
          ),
          
          const SizedBox(height: 12),

          AppEditTextWidget(controller: dbEditText, hint: S.of(context).settings_update_db, fontSize: 12),
          const SizedBox(height: 12),
          AppTextButton(
              onClick: () {
                if (dbEditText.text.isEmpty) return;

                showAppAlertDialog(context,
                    text: S.of(context).settings_update_db,
                    title: S.of(context).settings_update_db, 
                    isNoLighted: true,
                    callBack: () {
                      BlocProvider.of<SettingsCubit>(context).updateDb(dbEditText.text);
                    }
                );
              },
              text: S.of(context).settings_update_db
          ),
        ]
    );
  }
}
