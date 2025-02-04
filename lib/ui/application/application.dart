
import 'package:client_book_flutter/ui/main_page/main_page.dart';
import 'package:client_book_flutter/utils/colors.dart';
import 'package:flutter/material.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: AppColors.primary,
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