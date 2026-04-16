import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/data/services/auth_service.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminLoginController extends BaseController {
  final AuthService authService;

  AdminLoginController({required this.authService});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isObscure = true.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isObscure.value = !isObscure.value;
  }

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      showWarning('Vui lòng nhập đầy đủ email và mật khẩu!');
      return;
    }

    showLoading();

    try {
      bool success = await authService.loginAdmin(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (success) {
        Get.offAllNamed(AppRouter.adminDashboard);
      } else {
        showError(
          'Đăng nhập thất bại. Sai thông tin hoặc bạn không có quyền Admin!',
        );
      }
    } catch (e) {
      showError('Đăng nhập thất bại. Vui lòng thử lại sau.');
    } finally {
      hideLoading();
    }
  }
}
