// --- IMPORTS APP KHÁCH ---
import 'package:ecomerce/modules/admin/admin_categories/bindings/admin_categories_binding.dart';
import 'package:ecomerce/modules/admin/admin_categories/views/admin_categories_view.dart';
import 'package:ecomerce/modules/admin/admin_dashboard/bindings/admin_dashboard_binding.dart';
import 'package:ecomerce/modules/admin/admin_dashboard/views/admin_dashboard_view.dart';
import 'package:ecomerce/modules/app/auth/bindings/auth_binding.dart';
import 'package:ecomerce/modules/app/auth/views/forgot_password_view.dart';
import 'package:ecomerce/modules/app/auth/views/login_view.dart';
import 'package:ecomerce/modules/app/cart/bindings/cart_binding.dart';
import 'package:ecomerce/modules/app/cart/views/cart_view.dart';
import 'package:ecomerce/modules/app/dashboard/bindings/dashboard_binding.dart';
import 'package:ecomerce/modules/app/dashboard/views/dashboard_view.dart';
import 'package:ecomerce/modules/app/home/views/home_view.dart';
import 'package:ecomerce/modules/app/home/bindings/home_binding.dart';
import 'package:ecomerce/modules/app/notification/bindings/notification_binding.dart';
import 'package:ecomerce/modules/app/notification/views/notification_view.dart';
import 'package:ecomerce/modules/app/onboarding/bindings/onboarding_binding.dart';
import 'package:ecomerce/modules/app/onboarding/views/onboarding_view.dart';
import 'package:ecomerce/modules/app/profile/bindings/profile_binding.dart';
import 'package:ecomerce/modules/app/profile/views/profile_view.dart';
import 'package:ecomerce/modules/app/splash/bindings/splash_binding.dart';
import 'package:ecomerce/modules/app/splash/views/splash_view.dart';

// --- IMPORTS ADMIN KHU VỰC MỚI ---
import 'package:ecomerce/modules/admin/admin_login/bindings/admin_login_binding.dart';
import 'package:ecomerce/modules/admin/admin_login/views/admin_login_view.dart';

// Import thêm các modules Admin vừa tạo
import 'package:ecomerce/modules/admin/admin_products/bindings/admin_products_binding.dart';
import 'package:ecomerce/modules/admin/admin_products/views/admin_products_view.dart';
import 'package:ecomerce/modules/admin/admin_orders/bindings/admin_orders_binding.dart';
import 'package:ecomerce/modules/admin/admin_orders/views/admin_orders_view.dart';
import 'package:ecomerce/modules/admin/admin_customers/bindings/admin_customers_binding.dart';
import 'package:ecomerce/modules/admin/admin_customers/views/admin_customers_view.dart';

import 'package:ecomerce/routes/app_router.dart';
import 'package:get/get.dart';

class AppPage {
  static final INITIAL_ROUTER = AppRouter.splash;

  static final page = [
    // ==========================================
    // CÁC ROUTES CỦA APP KHÁCH HÀNG (Giữ nguyên)
    // ==========================================
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

    // ==========================================
    // CÁC ROUTES CỦA WEB ADMIN
    // ==========================================
    GetPage(
      name: AppRouter.adminLogin,
      page: () => const AdminLoginView(),
      binding: AdminLoginBinding(),
    ),

    GetPage(
      name: AppRouter.adminDashboard,
      page: () => const AdminDashboardView(),
      binding: AdminDashboardBinding(),
    ),

    GetPage(
      name: AppRouter.adminProducts,
      page: () => const AdminProductsView(),
      binding: AdminProductsBinding(),
    ),

    GetPage(
      name: AppRouter.adminOrders,
      page: () => const AdminOrdersView(),
      binding: AdminOrdersBinding(),
    ),

    GetPage(
      name: AppRouter
          .adminUsers, // Route dành cho Khách hàng/Người dùng trong Admin
      page: () => const AdminCustomersView(),
      binding: AdminCustomersBinding(),
    ),
    GetPage(
      name: AppRouter.adminCategories,
      page: () => const AdminCategoriesView(),
      binding: AdminCategoriesBinding(),
    ),
  ];
}
