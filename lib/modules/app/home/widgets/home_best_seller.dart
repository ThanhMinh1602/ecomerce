import 'package:ecomerce/core/components/product/horizontal_product_list_section.dart';
import 'package:ecomerce/modules/app/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeBestSeller extends GetView<HomeController> {
  const HomeBestSeller({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return HorizontalProductListSection(
        title: controller.currentTab.value,
        products: controller.bestSellers.toList(), 
        isLoading: controller.bestSellers.isEmpty, 
      );
    });
  }
}