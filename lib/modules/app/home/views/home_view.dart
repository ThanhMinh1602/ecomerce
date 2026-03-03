import 'package:ecomerce/core/components/text_field/custom_text_field.dart';
import 'package:ecomerce/core/constants/app_asset.dart' show AppAsset;
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/modules/app/home/widgets/home_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecomerce/modules/app/home/controllers/home_controller.dart';
import 'package:ecomerce/modules/app/home/widgets/horizontal_product_widget.dart';
import 'package:ecomerce/modules/app/home/widgets/vertical_product_widget.dart';
// ... các import khác

class HomeView extends GetView<HomeController> {
  HomeView({super.key});
  final categories = ['Best seller', 'Deals', 'Trending'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Obx(() => ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25.0)
            .copyWith(bottom: 38 + 71 + 16.0),
        children: [
          _buildSearch(),
          const SizedBox(height: 20.0),
          _buildBanner(),
          const SizedBox(height: 16.0),
          _buildCategory(),
          const SizedBox(height: 16.0),
          _buildBestSeller(),
          const SizedBox(height: 16.0),
          _buildCombo(),
        ],
      )),
    );
  }

  Widget _buildCategory() {
    return SizedBox(
      height: 35.0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Obx(() {
            bool isSelected = controller.currentTab.value == categories[index];
            return GestureDetector(
              onTap: () => controller.currentTab(categories[index]),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: isSelected ? AppColor.orange500 : AppColor.white,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: AppColor.k949494),
                ),
                child: Text(
                  categories[index],
                  style: AppStyle.smallContentBold.copyWith(
                    color: isSelected ? AppColor.white : AppColor.black500,
                  ),
                ),
              ),
            );
          });
        },
        separatorBuilder: (_, __) => const SizedBox(width: 13.0),
      ),
    );
  }

  Widget _buildBestSeller() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Obx(() => Text(controller.currentTab.value, style: AppStyle.smallContentBold)),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 258,
          child: controller.bestSellers.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
            itemCount: controller.bestSellers.length,
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              return VerticalProductWidget(product: controller.bestSellers[index]);
            },
            separatorBuilder: (_, __) => const SizedBox(width: 16.0),
          ),
        ),
      ],
    );
  }

  Widget _buildCombo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Combo', style: AppStyle.smallContentBold),
        const SizedBox(height: 16.0),
        controller.comboProducts.isEmpty
            ? const Text("Đang cập nhật Combo...")
            : ListView.separated(
          itemCount: controller.comboProducts.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return HorizontalProductWidget(product: controller.comboProducts[index]);
          },
          separatorBuilder: (_, __) => const SizedBox(height: 16.0),
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return CustomTextField(
      hintText: 'Enter the item you want to search for.',
      labelText: '',
      suffixIcon: AppAsset.camera,
      prefixIcon: AppAsset.search,
    );
  }

  Widget _buildBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Image.network(
        'https://thietkewebchuyen.com/wp-content/uploads/thiet-ke-banner-website-anh-bia-Facebook-shop-thoi-trang-quan-ao-10.jpg',
      ),
    );
  }
}