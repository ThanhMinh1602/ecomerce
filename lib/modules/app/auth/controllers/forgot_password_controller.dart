import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/core/utils/validator_util.dart';
import 'package:ecomerce/data/services/auth_service.dart';
// import 'package:ecomerce/modules/app/auth/services/auth_service.dart'; // Import AuthService của bạn
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends BaseController {
  final AuthService _authService;
  ForgotPasswordController(this._authService);

  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isFormValid = false.obs;


  @override
  void onInit() {
    super.onInit();
    emailController.addListener(_checkValidation);
  }

  void _checkValidation() {
    final emailError = ValidatorUtil.validateEmail(emailController.text);
    isFormValid.value = (emailError == null);
  }

  Future<void> sendResetEmail() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState?.validate() ?? false) {
      isLoading.value = true;

      try {
       final success = await _authService.sendPasswordResetEmail(emailController.text.trim());
       if(success){
         Get.back<String>(result: emailController.text);
       }else{
         showError('Thất bại', title: 'Vui lòng thử lại');
       }
      } catch (e) {
        print("Lỗi khi gửi email khôi phục: $e");
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}