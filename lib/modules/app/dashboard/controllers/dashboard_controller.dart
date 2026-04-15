import 'package:ecomerce/data/services/cart_service.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  var selectedIndex = 0.obs;

  final CartService _cartService = Get.find<CartService>();

  int get cartItemCount => _cartService.cartItems.length;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}
