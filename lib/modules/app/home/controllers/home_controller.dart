import 'package:get/get.dart';
import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/data/models/product_model.dart';
import 'package:ecomerce/data/services/product_service.dart';
import 'package:ecomerce/data/services/category_service.dart';

class HomeController extends BaseController {
  final ProductService _productService = Get.find<ProductService>();
  final CategoryService _categoryService = Get.find<CategoryService>();

  RxList<ProductModel> bestSellers = <ProductModel>[].obs;
  RxList<ProductModel> comboProducts = <ProductModel>[].obs;
  final RxString currentTab = 'Best seller'.obs;
  RxInt currentBannerIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    ever(currentTab, (String tabName) {
      bestSellers.bindStream(_productService.streamFilteredProducts(tabName));
    });

    bestSellers.bindStream(
      _productService.streamFilteredProducts(currentTab.value),
    );

    _initComboStream();
  }

  void changeTab(String tabName) {
    currentTab.value = tabName;
  }

  void _initComboStream() {

    _categoryService.streamCategories().listen((categoryList) {

      final categoryCombo = categoryList.firstWhereOrNull(
            (category) => category.name.toLowerCase() == 'combo',
      );

      if (categoryCombo != null) {

        comboProducts.bindStream(
          _productService.streamProductsByCategory(categoryCombo.name),
        );
      } else {

        comboProducts.clear();
        print("Cảnh báo: Không tìm thấy Category nào có tên là 'Combo' trên hệ thống.");
      }
    });
  }
}
