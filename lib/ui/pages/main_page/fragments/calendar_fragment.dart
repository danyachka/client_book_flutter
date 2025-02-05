

import 'package:client_book_flutter/ui/pages/main_page/main_page.dart';
import 'package:flutter/material.dart';

class CalendarFragment extends StatelessWidget {

  final ChangeFragmentCallback changeFragmentCallBack;

  const CalendarFragment({super.key, 
    required this.changeFragmentCallBack
  });

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.yellow);
  }
}