import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/modules/app/auth/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpRow extends GetView<LoginController> {
  const SignUpRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey('signup'),
      padding: const EdgeInsets.only(
        top: 16.0,
        bottom: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Don’t have account? ', style: AppStyle.smallContentRegular),
          GestureDetector(
            onTap: () => controller.onTapSignup(),
            child: Text(
              'Sign up',
              style: AppStyle.smallContentBold.copyWith(color: AppColor.orange500),
            ),
          ),
        ],
      ),
    );
  }
}