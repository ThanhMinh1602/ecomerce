import 'package:ecomerce/core/components/app_bar/small_app_bar.dart';
import 'package:ecomerce/modules/app/search/controllers/search_product_controller.dart';
import 'package:ecomerce/modules/app/search/widgets/hero_search_field.dart';
import 'package:ecomerce/modules/app/search/widgets/search_category_list.dart';
import 'package:ecomerce/modules/app/search/widgets/search_result_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SearchView extends GetView<SearchProductController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SmallAppBar(cartItemCount: 10,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: const [
            SizedBox(height: 12.0),
            HeroSearchField(),
            SizedBox(height: 24),
            SearchCategoryList(),
            SizedBox(height: 24),
            SearchResultList(),
          ],
        ),
      ),
    );
  }
}