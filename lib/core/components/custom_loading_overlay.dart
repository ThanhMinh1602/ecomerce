import 'dart:ui';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomLoadingOverlay extends StatelessWidget {
  final Widget child;
  final RxBool isLoading;

  const CustomLoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Obx(() {
          if (isLoading.value) {
            return Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.white.withOpacity(0.3),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColor.orange500,
                      strokeWidth: 4.0,
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}
