

import 'package:flutter/material.dart';

class AppSliverDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double min;
  final double max;

  AppSliverDelegate({
    required this.child,
    required this.min,
    required this.max,
  });

  @override
  double get minExtent => min;

  @override
  double get maxExtent => max;

  final GlobalKey childKey = GlobalKey();

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: KeyedSubtree(
      key: childKey,
      child: child,
    ));
  }

  @override
  bool shouldRebuild(AppSliverDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}