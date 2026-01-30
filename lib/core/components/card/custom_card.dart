import 'package:ecomerce/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.child,
    this.width,
    this.padding,
    this.height,
  });

  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding:
          padding ??
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(1, 1),
            blurRadius: 4.0,
            spreadRadius: 0,
            // ignore: deprecated_member_use
            color: AppColor.black500.withOpacity(0.25),
          ),
        ],
      ),
      child: child,
    );
  }
}
