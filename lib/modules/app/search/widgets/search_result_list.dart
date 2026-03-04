import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/modules/app/home/widgets/horizontal_product_widget.dart';
import 'package:ecomerce/modules/app/search/controllers/search_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchResultList extends GetView<SearchProductController> {
  const SearchResultList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded( // Giữ nguyên Expanded vì nó nằm trong Column của SearchView
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