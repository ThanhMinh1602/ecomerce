import 'package:ecomerce/data/services/auth_service.dart';
import 'package:ecomerce/data/services/cart_service.dart';
import 'package:ecomerce/data/services/category_service.dart';
import 'package:ecomerce/data/services/cloudinary_service.dart';
import 'package:ecomerce/data/services/order_service.dart';
import 'package:ecomerce/data/services/product_service.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<CloudinaryService>(CloudinaryService(), permanent: true);
    Get.put<ProductService>(ProductService(), permanent: true);
    Get.put<CategoryService>(CategoryService(), permanent: true);

    Get.put<CartService>(CartService(), permanent: true);
    Get.put<OrderService>(OrderService(), permanent: true);
  }
}
