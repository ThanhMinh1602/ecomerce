import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:get/get.dart';

class AdminDashboardController extends BaseController {
  final totalRevenue = 0.0.obs;
  final totalOrders = 0.obs;
  final totalProducts = 0.obs;
  final newCustomers = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  void fetchDashboardData() {
    showLoading();

    Future.delayed(const Duration(seconds: 1), () {
      totalRevenue.value = 15450.50;
      totalOrders.value = 125;

      newCustomers.value = 42;

      hideLoading();
    });
  }

  void logout() {
    Get.offAllNamed(AppRouter.adminLogin);
  }
}
