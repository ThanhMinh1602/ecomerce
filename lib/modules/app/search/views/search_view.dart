import 'package:ecomerce/core/components/app_bar/small_app_bar.dart';
import 'package:ecomerce/core/components/category_item.dart';
import 'package:ecomerce/core/components/text_field/search_field.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/modules/app/home/widgets/horizontal_product_widget.dart';
import 'package:ecomerce/modules/app/search/controllers/search_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchView extends GetView<SearchProductController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SmallAppBar(), 
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [

            _buildSearch(),
            const SizedBox(height: 24),
            _buildCategoryItemList(),
            const SizedBox(height: 24),
            _buildListSearch(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearch() {
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

  Widget _buildCategoryItemList() {
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

  Widget _buildListSearch() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Obx(() => Text(
            controller.searchQuery.isEmpty ? "Propose" : "Search Result",
            style: AppStyle.contentBold,
          )),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              
              if (controller.proposeProducts.isEmpty) {
                return const Center(child: Text("No products found."));
              }

              return ListView.separated(
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: controller.proposeProducts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return HorizontalProductWidget(
                    product: controller.proposeProducts[index],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}