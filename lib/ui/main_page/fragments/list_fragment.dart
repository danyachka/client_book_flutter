
import 'package:flutter/material.dart';

class ListFragment extends StatelessWidget {

  final ScrollController scrollController;

  const ListFragment({super.key, 
    required this.scrollController
  });

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.cyan);
  }
}
