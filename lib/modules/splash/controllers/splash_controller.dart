import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:get/get.dart';

class SplashController extends BaseController {
  @override
  void onInit() async {
    await Future.delayed(Duration(seconds: 3));
    Get.offNamed(AppRouter.onboarding);
    super.onInit();
  }
}
