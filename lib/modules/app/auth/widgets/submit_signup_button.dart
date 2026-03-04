import 'package:ecomerce/core/components/button/custom_button.dart';
import 'package:ecomerce/modules/app/auth/controllers/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmitSignupButton extends GetView<SignupController> {
  const SubmitSignupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return CustomButton(
        btnText: 'Confirm',
        onPressed: controller.isFormValid.value ? controller.signup : null,
      );
    });
  }
}