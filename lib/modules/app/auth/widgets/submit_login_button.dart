import 'package:ecomerce/core/components/button/custom_button.dart';
import 'package:ecomerce/modules/app/auth/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmitLoginButton extends GetView<LoginController> {
  const SubmitLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return CustomButton(
        btnText: 'Login',
        onPressed: controller.isFormValid.value
            ?  controller.login
            : null,
      );
    });
  }
}