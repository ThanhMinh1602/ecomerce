import 'package:ecomerce/core/components/category_item.dart';
import 'package:ecomerce/modules/app/search/controllers/search_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchCategoryList extends GetView<SearchProductController> {
  const SearchCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: List.generate(
        controller.categories.length > 10 ? 10 : controller.categories.length,
            (index) {
          final category = controller.categories[index];
          return CategoryItem(
            title: category.name,
            isSelected: controller.searchQuery.value == category.name,
            onTap: () => controller.selectCategory(category),
          );
        },
      ),
    ));
  }
}