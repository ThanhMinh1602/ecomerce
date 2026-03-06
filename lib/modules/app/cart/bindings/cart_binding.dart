import 'package:ecomerce/data/services/auth_service.dart';
import 'package:ecomerce/data/services/cart_service.dart';
import 'package:ecomerce/data/services/product_service.dart';
import 'package:ecomerce/modules/app/cart/controllers/cart_controller.dart';
import 'package:get/get.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CartController(
      Get.find<CartService>(),
      Get.find<AuthService>(),
      Get.find<ProductService>(),
    ));
  }
}
