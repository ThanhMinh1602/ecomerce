import 'package:get/get.dart';

class DashboardController extends GetxController {
  // Quản lý tab đang chọn
  var selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}
