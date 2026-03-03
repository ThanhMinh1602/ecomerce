import 'package:get/get.dart';
import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/data/models/product_model.dart';
import 'package:ecomerce/data/models/category_model.dart';
import 'package:ecomerce/data/services/product_service.dart';
import 'package:ecomerce/data/services/category_service.dart';

class SearchProductController extends BaseController {
  final ProductService _productService = Get.find<ProductService>();
  final CategoryService _categoryService = Get.find<CategoryService>();

  // --- Biến quan sát ---
  RxString searchQuery = "".obs;
  RxList<ProductModel> searchResults = <ProductModel>[].obs;
  RxList<ProductModel> proposeProducts = <ProductModel>[].obs;

  // Danh sách danh mục lấy từ Firebase [cite: 2026-03-03]
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    // 1. Lấy danh sách sản phẩm đề xuất (Propose)
    proposeProducts.bindStream(_productService.streamProducts());

    // 2. Lấy danh sách danh mục thay cho searchTags cũ [cite: 2026-03-03]
    categories.bindStream(_categoryService.streamCategories());

    // 3. Lắng nghe thay đổi tìm kiếm (Debounce 500ms)
    debounce(searchQuery, (query) => _performSearch(query), time: const Duration(milliseconds: 500));
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }
    // Lọc sản phẩm theo tên hoặc danh mục [cite: 2026-03-03]
    searchResults.value = proposeProducts
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void onSearchChanged(String value) => searchQuery.value = value;

  // Khi chọn một Category, chúng ta sẽ điền tên danh mục vào ô search [cite: 2026-03-03]
  void selectCategory(CategoryModel category) {
    searchQuery.value = category.name;
  }
}