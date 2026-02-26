import 'package:ecomerce/data/services/auth_service.dart';
import 'package:ecomerce/data/services/category_service.dart';
import 'package:ecomerce/data/services/cloudinary_service.dart';
import 'package:ecomerce/data/services/product_service.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Khởi tạo AuthService đầu tiên vì nó quan trọng nhất (quản lý user)
    Get.put<AuthService>(AuthService(), permanent: true);
    //
    // 2. Các Service khác
    Get.put<CloudinaryService>(CloudinaryService(), permanent: true);
    Get.put<ProductService>(ProductService(), permanent: true);
    Get.put<CategoryService>(CategoryService(), permanent: true);

    // Bạn có thể thêm các Service quản lý giỏ hàng, đơn hàng,... ở đây sau này
    // Get.put<CartService>(CartService(), permanent: true);
  }
}
