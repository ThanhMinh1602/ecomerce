import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/core/utils/validator_util.dart';
import 'package:ecomerce/data/services/auth_service.dart';
import 'package:ecomerce/data/services/preferences_service.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends BaseController {
  final AuthService _authService;
  final PreferencesService _preferencesService = PreferencesService();

  LoginController(this._authService);

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

  Future<void> login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState?.validate() ?? false) {
      showLoading();

      final isSuccess = await _authService.loginUser(
        emailController.text.trim(),
        passwordController.text,
      );

      hideLoading();

      if (isSuccess) {
        // Save login state and user email
        await _preferencesService.setUserLoggedIn(true);
        await _preferencesService.setUserEmail(emailController.text.trim());
        Get.offAllNamed(AppRouter.dashboard);
      } else {
        showError(
          'Đăng nhập thất bại',
          title: 'Email hoặc mật khẩu không chính xác. Vui lòng thử lại.',
        );
      }
    }
  }

  // ==========================================
  // THÊM MỚI: Xử lý sự kiện đăng nhập MXH
  // ==========================================

  Future<void> loginWithGoogle() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showLoading();

    final isSuccess = await _authService.loginWithGoogle();

    hideLoading();

    if (isSuccess) {
      // Save login state
      await _preferencesService.setUserLoggedIn(true);
      Get.offAllNamed(AppRouter.dashboard);
    } else {
      showError(
        'Đăng nhập Google thất bại',
        title: 'Đã có lỗi xảy ra hoặc bạn đã hủy thao tác. Vui lòng thử lại.',
      );
    }
  }

  Future<void> loginWithFacebook() async {
    FocusManager.instance.primaryFocus?.unfocus();
    showLoading();

    final isSuccess = await _authService.loginWithFacebook();

    hideLoading();

    if (isSuccess) {
      // Save login state
      await _preferencesService.setUserLoggedIn(true);
      Get.offAllNamed(AppRouter.dashboard);
    } else {
      showError(
        'Đăng nhập Facebook thất bại',
        title: 'Đã có lỗi xảy ra hoặc bạn đã hủy thao tác. Vui lòng thử lại.',
      );
    }
  }

  // ==========================================

  Future<void> onTapSignup() async {
    final result = await Get.toNamed(Get.currentRoute + AppRouter.signup);
    if (result != null) {
      emailController.text = result;
      showSuccess(
        'Đăng ký thành công',
        title: 'Tài khoản với email $result đã sẵn sàng.',
      );
      _checkValidation();
    }
  }

  Future<void> onTapForgot() async {
    final result = await Get.toNamed(
      Get.currentRoute + AppRouter.forgotPassword,
    );
    if (result != null) {
      emailController.text = result;
      showSuccess('Gửi mail thành công', title: 'Kiểm tra $result');
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