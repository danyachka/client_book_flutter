
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:client_book_flutter/core/utils/s.dart';
import 'package:flutter/material.dart';

class _AppAlertDialog extends StatelessWidget {
  final String text;
  final String title;
  final AppAlertDialogCallBack callBack;
  final AppAlertDialogCallBack? noCallBack;
  final bool isNoLighted;
  const _AppAlertDialog({
    required this.text,
    required this.title,
    required this.callBack,
    this.noCallBack,
    this.isNoLighted = true
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: AppColors.darkBackground,
        title: Text(
          title,
          style: const TextStyle(
              color: AppColors.white,
              fontSize: 15,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold),
        ),
        content: Text(
          text,
          style: const TextStyle(
              color: AppColors.white,
              fontSize: 13,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              callBack();
            },
            style: TextButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text(
              S.of(context).yes,
              style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 13,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (noCallBack != null) noCallBack!();
              },
              style: TextButton.styleFrom(backgroundColor: isNoLighted? AppColors.primary: AppColors.gray),
              child: Text(
                S.of(context).no,
                style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 13,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold),
              ))
        ]);
  }
}

typedef AppAlertDialogCallBack = void Function();

void showAppAlertDialog(BuildContext context, {
    required String text,
    required String title,
    required AppAlertDialogCallBack callBack,
    AppAlertDialogCallBack? noCallBack,
    bool isNoLighted = true
}) {
   showDialog(
    context: context,
    builder: (context) {
      return _AppAlertDialog(
        text: text,
        title: title,
        callBack: callBack,
        noCallBack: noCallBack,
        isNoLighted: isNoLighted,
      );
    }
   );
}
