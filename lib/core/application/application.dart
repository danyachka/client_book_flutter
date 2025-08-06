
import 'package:client_book_flutter/core/widgets/app_system_overlay/app_system_overlay.dart';
import 'package:client_book_flutter/features/main/page/main_page.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:flutter/material.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: S.supportedLocales,
      localizationsDelegates: S.localizationDelegates,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.darkBackground,
        focusColor: AppColors.primary,
        highlightColor: AppColors.primary,
        splashColor: AppColors.primary,
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
          systemOverlayStyle: getAppSystemOverlayStyle()
        )
      ),
      themeMode: ThemeMode.dark,
      home: const MainPage()
    );
  }
}