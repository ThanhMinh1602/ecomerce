import 'package:ecomerce/core/components/text_field/search_field.dart';
import 'package:ecomerce/modules/app/search/controllers/search_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeroSearchField extends GetView<SearchProductController> {
  const HeroSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'search-field',
      child: Material(
        color: Colors.transparent,
        child: SearchField(
          autofocus: true,
          controller: controller.searchController,
          onChanged: (value) => controller.onSearchChanged(value),
        ),
      ),
    );
  }
}