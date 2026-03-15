import 'package:ecomerce/modules/app/home/widgets/home_app_bar_widget.dart';
import 'package:ecomerce/modules/app/home/widgets/home_banner.dart';
import 'package:ecomerce/modules/app/home/widgets/home_best_seller.dart';
import 'package:ecomerce/modules/app/home/widgets/home_category_tabs.dart';
import 'package:ecomerce/modules/app/home/widgets/home_combo_list.dart';
import 'package:ecomerce/modules/app/home/widgets/home_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecomerce/modules/app/home/controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final categories = ['Best seller', 'Deals', 'Trending'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 25.0,
        ).copyWith(bottom: 38 + 71 + 16.0),
        children: [
          const HomeSearchField(),
          const SizedBox(height: 20.0),
          const HomeBanner(),
          const SizedBox(height: 16.0),
          HomeCategoryTabs(categories: categories),
          const SizedBox(height: 16.0),
          const HomeBestSeller(),
          const SizedBox(height: 16.0),
          const HomeComboList(),
        ],
      ),
    );
  }
}
