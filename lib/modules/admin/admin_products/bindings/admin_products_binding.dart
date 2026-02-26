import 'package:ecomerce/data/services/category_service.dart';
import 'package:ecomerce/data/services/cloudinary_service.dart';
import 'package:ecomerce/data/services/product_service.dart';
import 'package:get/get.dart';
import '../controllers/admin_products_controller.dart';

class AdminProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminProductsController>(
      () => AdminProductsController(
        productService: Get.find<ProductService>(),
        categoryService: Get.find<CategoryService>(),
        cloudinaryService: Get.find<CloudinaryService>(),
      ),
    );
  }
}
