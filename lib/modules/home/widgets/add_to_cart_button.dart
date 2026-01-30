import 'package:ecomerce/core/constants/app_color.dart';
import 'package:flutter/material.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 16.0,
      backgroundColor: AppColor.orange500,
      child: Icon(Icons.add, size: 16.0, color: AppColor.white),
    );
  }
}
