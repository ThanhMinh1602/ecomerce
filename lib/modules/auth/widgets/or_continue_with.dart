import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:flutter/material.dart';

class OrContinueWith extends StatelessWidget {
  const OrContinueWith({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 19.0,
      children: [
        Expanded(child: Divider(color: AppColor.black200, thickness: 0.5)),
        Text(
          'Or continue with',
          style: AppStyle.smallContentRegular.copyWith(
            color: AppColor.black200,
          ),
        ),
        Expanded(child: Divider(color: AppColor.black200, thickness: 0.5)),
      ],
    );
  }
}
