class AppRouter {
  // --- ROUTES APP KHÁCH HÀNG ---
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String notification = '/notification';
  static const String cart = '/cart';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String productDetails = '/product-details';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order-success';
  static const String orderDetails = '/order-details';

  // --- ROUTES WEB ADMIN ---
  static const String adminLogin = '/admin-login';
  static const String adminDashboard =
      '/admin-dashboard'; // Trang tổng quan (Chart, Thống kê)
  static const String adminProducts = '/admin-products'; // Quản lý sản phẩm
  static const String adminCategories = '/admin-categories'; // Quản lý danh mục
  static const String adminOrders = '/admin-orders'; // Quản lý đơn hàng
  static const String adminUsers = '/admin-users'; // Quản lý khách hàng
}
