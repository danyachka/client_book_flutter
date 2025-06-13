
import 'package:client_book_flutter/features/main/page/main_page.dart';
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:flutter/material.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: S.supportedLocales,
      localizationsDelegates: S.localizationDelegates,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.darkBackground,
        focusColor: AppColors.white,
        highlightColor: AppColors.white,
        splashColor: AppColors.white,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: AppColors.white),
          color: AppColors.primary,
          foregroundColor: AppColors.darkBackground
        )
      ),
      home: const MainPage()
    );
  }
}