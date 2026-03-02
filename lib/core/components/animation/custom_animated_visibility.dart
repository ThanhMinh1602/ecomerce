import 'package:flutter/material.dart';

class CustomAnimatedVisibility extends StatelessWidget {
  final bool visible;
  final Widget child;
  final Duration duration;

  const CustomAnimatedVisibility({
    super.key,
    required this.visible,
    required this.child,
    this.duration = const Duration(milliseconds: 300), // Mặc định 300ms
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
            axisAlignment: -1.0, // Thu nhỏ về phía trên để không bị giật layout
            child: child,
          ),
        );
      },
      // Thêm key để AnimatedSwitcher nhận diện được khi nào rỗng
      child: visible
          ? child
          : const SizedBox.shrink(key: ValueKey('none_animated_box')),
    );
  }
}
