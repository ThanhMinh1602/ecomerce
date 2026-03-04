import 'package:ecomerce/core/components/category_item.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/modules/app/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeCategoryTabs extends GetView<HomeController> {
  final List<String> categories;

  const HomeCategoryTabs({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Obx(() {
            bool isSelected = controller.currentTab.value == categories[index];
            return CategoryItem(
              title: categories[index],
              isSelected: isSelected,
              textStyle: AppStyle.smallContentBold,
              onTap: () => controller.currentTab(categories[index]),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            );
          });
        },
        separatorBuilder: (_, __) => const SizedBox(width: 13.0),
      ),
    );
  }
}