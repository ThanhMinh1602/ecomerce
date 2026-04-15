import 'package:ecomerce/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class AddToCartButton extends StatelessWidget {
  final VoidCallback? onTap;

  const AddToCartButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const CircleAvatar(
        radius: 16.0,
        backgroundColor: AppColor.orange500,
        child: Icon(Icons.add, size: 16.0, color: AppColor.white),
      ),
    );
  }
}
