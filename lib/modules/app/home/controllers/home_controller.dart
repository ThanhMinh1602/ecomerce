import 'package:get/get.dart';
import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/data/models/product_model.dart';
import 'package:ecomerce/data/services/product_service.dart';
import 'package:ecomerce/data/services/category_service.dart';

class HomeController extends BaseController {
  final ProductService _productService = Get.find<ProductService>();
  final CategoryService _categoryService = Get.find<CategoryService>();

  // Danh sách quan sát (Rx)
  RxList<ProductModel> bestSellers = <ProductModel>[].obs;
  RxList<ProductModel> comboProducts = <ProductModel>[].obs;
  final RxString currentTab = 'Best seller'.obs;

  @override
  void onInit() {
    super.onInit();
    ever(currentTab, (String tabName) {
      bestSellers.bindStream(_productService.streamFilteredProducts(tabName));
    });

    // Khởi tạo stream mặc định
    bestSellers.bindStream(_productService.streamFilteredProducts(currentTab.value));

    // 2. Tự động tìm danh mục "Combo" và lấy sản phẩm tương ứng [cite: 2026-03-03]
    _initComboStream();
  }
  void changeTab(String tabName) {
    currentTab.value = tabName;
  }
  void _initComboStream() {
    _categoryService.streamCategories().listen((categories) {
      final comboCat = categories.firstWhereOrNull(
              (c) => c.name.toLowerCase().contains('combo')
      );
      if (comboCat != null) {
        comboProducts.bindStream(
            _productService.streamProductsByCategory(comboCat.id)
        );
      }
    });
    print('comboProducts: ${comboProducts.value}');
  }


}