import 'package:ecomerce/modules/admin/admin_categories/bindings/admin_categories_binding.dart';
import 'package:ecomerce/modules/admin/admin_categories/views/admin_categories_view.dart';
import 'package:ecomerce/modules/admin/admin_dashboard/bindings/admin_dashboard_binding.dart';
import 'package:ecomerce/modules/admin/admin_dashboard/views/admin_dashboard_view.dart';
import 'package:ecomerce/modules/app/auth/bindings/auth_binding.dart';
import 'package:ecomerce/modules/app/auth/views/forgot_password_view.dart';
import 'package:ecomerce/modules/app/auth/views/login_view.dart';
import 'package:ecomerce/modules/app/auth/views/signup_view.dart';
import 'package:ecomerce/modules/app/cart/bindings/cart_binding.dart';
import 'package:ecomerce/modules/app/cart/bindings/checkout_binding.dart';
import 'package:ecomerce/modules/app/cart/views/cart_view.dart';
import 'package:ecomerce/modules/app/cart/views/checkout_view.dart';
import 'package:ecomerce/modules/app/dashboard/bindings/dashboard_binding.dart';
import 'package:ecomerce/modules/app/dashboard/views/dashboard_view.dart';
import 'package:ecomerce/modules/app/home/views/home_view.dart';
import 'package:ecomerce/modules/app/home/bindings/home_binding.dart';
import 'package:ecomerce/modules/app/notification/bindings/notification_binding.dart';
import 'package:ecomerce/modules/app/notification/views/notification_menu_detail_view.dart';
import 'package:ecomerce/modules/app/notification/views/notification_view.dart';
import 'package:ecomerce/modules/app/onboarding/bindings/onboarding_binding.dart';
import 'package:ecomerce/modules/app/onboarding/views/onboarding_view.dart';
import 'package:ecomerce/modules/app/product_detail/bindings/product_detail_binding.dart';
import 'package:ecomerce/modules/app/product_detail/views/product_detail_view.dart';
import 'package:ecomerce/modules/app/profile/bindings/my_detail_binding.dart';
import 'package:ecomerce/modules/app/profile/bindings/profile_binding.dart';
import 'package:ecomerce/modules/app/profile/views/my_details_view.dart';
import 'package:ecomerce/modules/app/profile/views/my_orders_view.dart';
import 'package:ecomerce/modules/app/profile/views/profile_view.dart';
import 'package:ecomerce/modules/app/profile/views/vouchers_offers_view.dart';
import 'package:ecomerce/modules/app/search/bindings/search_binding.dart';
import 'package:ecomerce/modules/app/search/views/search_view.dart';
import 'package:ecomerce/modules/app/splash/bindings/splash_binding.dart';
import 'package:ecomerce/modules/app/splash/views/splash_view.dart';

import 'package:ecomerce/modules/admin/admin_login/bindings/admin_login_binding.dart';
import 'package:ecomerce/modules/admin/admin_login/views/admin_login_view.dart';

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
      page: () => LoginView(),
      binding: AuthBinding(),
      children: [
        GetPage(
          name: AppRouter.forgotPassword,
          page: () => const ForgotPasswordView(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: AppRouter.signup,
          page: () => SignupView(),
          binding: AuthBinding(),
        ),
      ],
    ),
    GetPage(
      name: AppRouter.dashboard,
      page: () => const DashboardView(),
      bindings:[ DashboardBinding(),CartBinding(), ProfileBinding()],
    ),
    GetPage(
      name: AppRouter.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRouter.search,
      page: () => SearchView(),
      binding: SearchBinding(),
      transition: Transition.fade,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRouter.productDetails,
      page: () => ProductDetailView(),
      binding: ProductDetailBinding(),
      transition: Transition.fade,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRouter.cart,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: AppRouter.checkout,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: AppRouter.notification,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: AppRouter.notificationMenuDetail,
      page: () => const NotificationMenuDetailView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: AppRouter.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRouter.myDetails,
      page: () => const MyDetailsView(),
      binding: MyDetailBinding(),
    ),
    GetPage(
      name: AppRouter.myOrders,
      page: () => const MyOrdersView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRouter.vouchersOffers,
      page: () => const VouchersOffersView(),
      binding: ProfileBinding(),
    ),
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
      name: AppRouter.adminUsers,
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
