import 'package:ecomerce/core/components/app_bar/small_app_bar.dart';
import 'package:ecomerce/core/components/text_field/search_field.dart';
import 'package:ecomerce/modules/app/search/controllers/search_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchView extends GetView<SearchProductController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: SmallAppBar(),
    body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25.0),
      children: [
      _buildSearch()
    ],),
    );
  }
  Widget _buildSearch() {
    return Hero(
      tag: 'search-field',
      child: Material(
        color: Colors.transparent,
        child: SearchField(
          // controller: controller.searchController,
          onChanged: (value) => controller.onSearchChanged(value), // Tìm kiếm real-time [cite: 2026-03-03]
          // onFieldSubmitted: (value) => controller.performSearch(value), // Nhấn Enter để tìm [cite: 2026-03-03]
        ),
      ),
    );
  }
}
