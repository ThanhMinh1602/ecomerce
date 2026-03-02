import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/core/utils/validator_util.dart';
import 'package:ecomerce/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends BaseController {
  final AuthService _authService;
  SignupController(this._authService);

  final signupFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();

    nameController.addListener(_checkValidation);
    emailController.addListener(_checkValidation);
    passwordController.addListener(_checkValidation);
    confirmPasswordController.addListener(_checkValidation);
  }

  void _checkValidation() {
    final nameError = ValidatorUtil.validateEmpty(
      nameController.text,
      'User Name',
    );
    final emailError = ValidatorUtil.validateEmail(emailController.text);
    final passError = ValidatorUtil.validatePassword(passwordController.text);
    final confirmError = ValidatorUtil.validateMatchPassword(
      confirmPasswordController.text,
      passwordController.text,
    );

    isFormValid.value =
        (nameError == null &&
        emailError == null &&
        passError == null &&
        confirmError == null);
  }

  Future<void> signup() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (signupFormKey.currentState?.validate() ?? false) {
      isLoading.value = true;

      try {
        bool success = await _authService.registerUser(
          emailController.text.trim(),
          passwordController.text.trim(),
          nameController.text.trim(),
        );

        if (success) {
          Get.back<String>(result: emailController.text.trim());
        } else {
          showError(
            'Thất bại',
            title: 'Đăng ký không thành công. Vui lòng thử lại.',
          );
        }
      } catch (e) {
        Get.snackbar('Lỗi', e.toString());
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
