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

  RxString searchQuery = "".obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  RxList<ProductModel> proposeProducts = <ProductModel>[].obs;

  StreamSubscription? _productSubscription;

  @override
  void onInit() {
    super.onInit();

    categories.bindStream(_categoryService.streamCategories());

    _switchToStream(_productService.streamProposeProducts());

    debounce(
      searchQuery,
      (query) => _performSearch(query.toString()),
      time: const Duration(milliseconds: 500),
    );
  }

  void _switchToStream(Stream<List<ProductModel>> newStream) {
    _productSubscription?.cancel();
    _productSubscription = newStream.listen((list) {
      proposeProducts.assignAll(list);
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      _switchToStream(_productService.streamProposeProducts());
    } else {
      _switchToStream(_productService.streamSearchFlexible(query));
    }
  }

  void onSearchChanged(String value) => searchQuery.value = value;

  void selectCategory(CategoryModel category) {
    searchController.text = category.name;
    searchQuery.value = category.name;
  }

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
