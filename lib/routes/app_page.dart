import 'package:ecomerce/modules/auth/bindings/auth_binding.dart';
import 'package:ecomerce/modules/auth/views/forgot_password_view.dart';
import 'package:ecomerce/modules/auth/views/login_view.dart';
import 'package:ecomerce/modules/cart/bindings/cart_binding.dart';
import 'package:ecomerce/modules/cart/views/cart_view.dart';
import 'package:ecomerce/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:ecomerce/modules/dashboard/views/dashboard_view.dart';
import 'package:ecomerce/modules/home/views/home_view.dart';
import 'package:ecomerce/modules/notification/bindings/notification_binding.dart';
import 'package:ecomerce/modules/notification/views/notification_view.dart';
import 'package:ecomerce/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:ecomerce/modules/onboarding/views/onboarding_view.dart';
import 'package:ecomerce/modules/profile/bindings/profile_binding.dart';
import 'package:ecomerce/modules/profile/views/profile_view.dart';
import 'package:ecomerce/modules/splash/bindings/splash_binding.dart';
import 'package:ecomerce/modules/splash/views/splash_view.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';

class AppPage {
  static final INITIAL_ROUTER = AppRouter.splash;
  static final page = [
    GetPage(
      name: AppRouter.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRouter.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRouter.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
      children: [
        GetPage(
          name: AppRouter.forgotPassword,
          page: () => const ForgotPasswordView(),
          binding: AuthBinding(),
        ),
      ],
    ),
    GetPage(
      name: AppRouter.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      children: [
        GetPage(
          name: AppRouter.home,
          page: () => HomeView(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: AppRouter.cart,
          page: () => const CartView(),
          binding: CartBinding(),
        ),
        GetPage(
          name: AppRouter.notification,
          page: () => const NotificationView(),
          binding: NotificationBinding(),
        ),
        GetPage(
          name: AppRouter.profile,
          page: () => const ProfileView(),
          binding: ProfileBinding(),
        ),
      ],
    ),
  ];
}
