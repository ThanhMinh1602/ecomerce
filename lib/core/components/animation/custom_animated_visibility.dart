import 'package:flutter/material.dart';

class CustomAnimatedVisibility extends StatelessWidget {
  final bool visible;
  final Widget child;
  final Duration duration;

  const CustomAnimatedVisibility({
    super.key,
    required this.visible,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1.0,
            child: child,
          ),
        );
      },

      child: visible
          ? child
          : const SizedBox.shrink(key: ValueKey('none_animated_box')),
    );
  }
}
