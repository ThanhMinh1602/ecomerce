import 'package:ecomerce/core/components/product/horizontal_product_list_section.dart';
import 'package:ecomerce/modules/app/home/widgets/vertical_product_widget.dart';
import 'package:ecomerce/modules/app/search/controllers/search_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductProposeList extends GetView<SearchProductController> {
  const ProductProposeList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => HorizontalProductListSection(
        isLoading: controller.isLoading.value,
        title: 'Propose',
        products: controller.proposeProducts.toList(),
        type: VerticalProductType.detail,
      ),
    );
  }
}
