import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/data/services/auth_service.dart';
import 'package:ecomerce/data/services/preferences_service.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:get/get.dart';

class SplashController extends BaseController {
  final AuthService _authService = Get.find<AuthService>();
  final PreferencesService _preferencesService = PreferencesService();

  @override
  void onInit() async {
    await Future.delayed(const Duration(seconds: 3));
    await _navigateToNextScreen();
    super.onInit();
  }

  Future<void> _navigateToNextScreen() async {
    // Check if user is already logged in
    final isLoggedIn = await _preferencesService.isUserLoggedIn();
    final isOnboardingShown = await _preferencesService.isOnboardingShown();

    if (isLoggedIn && _authService.firebaseUser.value != null) {
      // User is logged in, go to dashboard
      Get.offNamed(AppRouter.dashboard);
    } else if (isOnboardingShown) {
      // Onboarding was already shown, go to login
      Get.offNamed(AppRouter.login);
    } else {
      // First time user, show onboarding
      Get.offNamed(AppRouter.onboarding);
    }
  }
}
