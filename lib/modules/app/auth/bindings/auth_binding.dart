import 'package:ecomerce/modules/app/auth/controllers/forgot_password_controller.dart';
import 'package:ecomerce/modules/app/auth/controllers/login_controller.dart';
import 'package:ecomerce/modules/app/auth/controllers/signup_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController(Get.find()));
    Get.lazyPut(() => SignupController(Get.find()));
    Get.lazyPut(()=> ForgotPasswordController(Get.find()));

  }
}
