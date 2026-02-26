import 'package:ecomerce/data/services/auth_service.dart';
import 'package:get/get.dart';
import '../controllers/admin_login_controller.dart';
// Nhớ import AuthService của bạn
// import 'package:ecomerce/core/services/auth_service.dart';

class AdminLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminLoginController>(
      () => AdminLoginController(authService: Get.find<AuthService>()),
    );
  }
}
