import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/modules/app/auth/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordButton extends GetView<LoginController> {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () => controller.onTapForgot(),
        child: Text(
          'Forgot password?',
          style: AppStyle.smallContentBold.copyWith(color: AppColor.orange500),
        ),
      ),
    );
  }
}