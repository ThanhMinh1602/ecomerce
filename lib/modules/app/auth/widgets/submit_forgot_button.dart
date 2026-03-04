import 'package:ecomerce/core/components/button/custom_button.dart';
import 'package:ecomerce/modules/app/auth/controllers/forgot_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmitForgotButton extends GetView<ForgotPasswordController> {
  const SubmitForgotButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return CustomButton(
        btnText: 'Confirm',
        onPressed: controller.isFormValid.value ? controller.sendResetEmail : null,
      );
    });
  }
}