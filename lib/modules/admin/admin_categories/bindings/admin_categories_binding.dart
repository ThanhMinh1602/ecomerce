import 'package:ecomerce/data/services/category_service.dart';
import 'package:ecomerce/data/services/cloudinary_service.dart';
import 'package:get/get.dart';
import '../controllers/admin_categories_controller.dart';

class AdminCategoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminCategoriesController>(
      () => AdminCategoriesController(
        cloudinaryService: Get.find<CloudinaryService>(),
        categoryService: Get.find<CategoryService>(),
      ),
    );
  }
}
