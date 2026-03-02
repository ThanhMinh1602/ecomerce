import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/core/utils/validator_util.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends BaseController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();

    emailController.addListener(_checkValidation);
    passwordController.addListener(_checkValidation);
  }

  void _checkValidation() {
    final emailError = ValidatorUtil.validateEmail(emailController.text);
    final passError = ValidatorUtil.validatePassword(passwordController.text);

    isFormValid.value = (emailError == null && passError == null);
  }

  void login() {
    print("Đăng nhập thành công với: ${emailController.text}");
  }

  Future<void> onTapSignup() async {
    final result = await Get.toNamed(Get.currentRoute + AppRouter.signup);
    print('result123: $result');
    if (result != null) {
      emailController.text = result;

      showSuccess(
        'Đăng ký thành công',
        title: 'Tài khoản với email $result đã sẵn sàng.',
      );

      _checkValidation();
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
