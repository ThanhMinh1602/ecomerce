import 'dart:async';
import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/data/models/category_model.dart';
import 'package:ecomerce/data/models/product_model.dart';
import 'package:ecomerce/data/services/category_service.dart';
import 'package:ecomerce/data/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchProductController extends BaseController {
  final ProductService _productService = Get.find<ProductService>();
  final CategoryService _categoryService = Get.find<CategoryService>();
  final searchController = TextEditingController();

  // --- Biến quan sát ---
  RxString searchQuery = "".obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  // Đây là danh sách "sống" sẽ thay đổi nội dung tùy theo trạng thái search
  RxList<ProductModel> proposeProducts = <ProductModel>[].obs;

  // Quản lý subscription để chuyển đổi stream
  StreamSubscription? _productSubscription;

  @override
  void onInit() {
    super.onInit();

    // 1. Init: Lấy danh sách danh mục
    categories.bindStream(_categoryService.streamCategories());

    // 2. Init: Mặc định hiển thị danh sách Propose (Gợi ý)
    _switchToStream(_productService.streamProposeProducts());

    // 3. Lắng nghe thay đổi tìm kiếm
    debounce(searchQuery, (query) => _performSearch(query.toString()),
        time: const Duration(milliseconds: 500));
  }

  /// Hàm quan trọng: Chuyển đổi nguồn dữ liệu cho danh sách hiển thị
  void _switchToStream(Stream<List<ProductModel>> newStream) {
    _productSubscription?.cancel(); // Hủy stream cũ trước khi gán stream mới
    _productSubscription = newStream.listen((list) {
      proposeProducts.assignAll(list);
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      // Nếu xóa trắng ô search, quay lại hiện danh sách Gợi ý
      _switchToStream(_productService.streamProposeProducts());
    } else {
      // Nếu có chữ, danh sách proposeProducts sẽ được gán lại bằng list search
      _switchToStream(_productService.streamSearchFlexible(query));
    }
  }

  void onSearchChanged(String value) => searchQuery.value = value;

  void selectCategory(CategoryModel category) {
    searchController.text = category.name;
    searchQuery.value = category.name;
  }

  // Nút xóa nhanh nội dung tìm kiếm
  void clearSearch() {
    searchController.clear();
    searchQuery.value = "";
  }

  @override
  void onClose() {
    _productSubscription?.cancel();
    searchController.dispose();
    super.onClose();
  }
}