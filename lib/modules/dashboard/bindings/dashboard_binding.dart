import 'package:ecomerce/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:ecomerce/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
  }
}
