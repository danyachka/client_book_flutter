
import 'package:client_book_flutter/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _OverlayLayout extends StatefulWidget {

  final double? topOffsetY;
  final double? bottomOffsetY;

  final Widget child;

  const _OverlayLayout({
    required this.topOffsetY, 
    required this.bottomOffsetY,
    required this.child
  });

  @override
  State<_OverlayLayout> createState() => __OverlayLayoutState();
}

class __OverlayLayoutState extends State<_OverlayLayout> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200)
    );
    _animation = CurvedAnimation(
      parent: _controller, 
      curve: Curves.easeInOut
    ).drive(Tween(begin: 0.0, end: 1.0));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    context.read<AppOverlayCallBack>().close = () {
      _controller.reverse().whenCompleteOrCancel(() {
        context.read<AppOverlayCallBack>().remove();
      });
    };

    return GestureDetector(
        onTap: () => context.read<AppOverlayCallBack>().close!(),
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: widget.topOffsetY,
              bottom: widget.bottomOffsetY,
              child: Material(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _animation, 
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: AppColors.overlayBackground,
                        ),
                        child: widget.child
                      )
                    )
                  ],
                )
              )
            )
          ]
        )
      );
  }
}

const _yOverlayOffset = 6;

void showAppOverlay({
  required BuildContext context,
  required Widget child
}) {
    final cardRenderBox = context.findRenderObject() as RenderBox;
    final cardPosition = cardRenderBox.localToGlobal(Offset.zero);

    final screenHeight = MediaQuery.of(context).size.height;

    double? top;
    double? bottom;

    if (cardPosition.dy + cardRenderBox.size.height < screenHeight * 0.65) {
      top = cardPosition.dy + cardRenderBox.size.height + _yOverlayOffset;
    } else {
      bottom = screenHeight - (cardPosition.dy) + _yOverlayOffset;
    }

    OverlayEntry? overlayEntry;

    final closeCallBack = AppOverlayCallBack(() => overlayEntry?.remove());

    overlayEntry = OverlayEntry(
      builder: (context) =>  Provider.value(
        value: closeCallBack,
        child: _OverlayLayout(topOffsetY: top, bottomOffsetY: bottom, child: child) 
      ) 
    );

    Overlay.of(context).insert(overlayEntry);
}

class AppOverlayCallBack {
  final void Function() remove;
  void Function()? close;

  AppOverlayCallBack(this.remove);
}