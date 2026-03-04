import 'package:ecomerce/core/components/category_item.dart';
import 'package:ecomerce/core/components/text_field/search_field.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/modules/app/home/widgets/home_app_bar_widget.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecomerce/modules/app/home/controllers/home_controller.dart';
import 'package:ecomerce/modules/app/home/widgets/horizontal_product_widget.dart';
import 'package:ecomerce/modules/app/home/widgets/vertical_product_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});
  final categories = ['Best seller', 'Deals', 'Trending'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: ListView(
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
      ),
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

  Widget _buildBestSeller() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Text(controller.currentTab.value, style: AppStyle.smallContentBold)),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 258,
          child: Obx(() => controller.bestSellers.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
            itemCount: controller.bestSellers.length,
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              return VerticalProductWidget(product: controller.bestSellers[index]);
            },
            separatorBuilder: (_, __) => const SizedBox(width: 16.0),
          )),
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
        Obx(() => controller.comboProducts.isEmpty
            ? const Text("Đang cập nhật Combo...")
            : ListView.separated(
          itemCount: controller.comboProducts.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return HorizontalProductWidget(product: controller.comboProducts[index]);
          },
          separatorBuilder: (_, __) => const SizedBox(height: 16.0),
        )),
      ],
    );
  }

  Widget _buildSearch() {
    return Hero(
      tag: 'search-field',
      child: Material(
        color: Colors.transparent,
        child: SearchField(
          readOnly: true,
          onTap: () => Get.toNamed(Get.currentRoute + AppRouter.search),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    final List<Map<String, String>> banners = [
      {
        'image': 'https://img.freepik.com/free-photo/summer-fashion-concept-with-accessories_23-2148160216.jpg',
        'title': 'Summer',
        'subtitle': 'SALE',
        'discount': '50% OFF'
      },
      {
        'image': 'https://img.freepik.com/free-photo/elegant-woman-stylish-dress-posing-beach_23-2148154625.jpg',
        'title': 'New',
        'subtitle': 'ARRIVALS',
        'discount': 'BUY 1 GET 1'
      }, {
        'image': 'https://img.freepik.com/free-photo/elegant-woman-stylish-dress-posing-beach_23-2148154625.jpg',
        'title': 'New',
        'subtitle': 'ARRIVALS',
        'discount': 'BUY 1 GET 1'
      },
    ];

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 165.0,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, reason) {
              controller.currentBannerIndex.value = index;
            },
          ),
          items: banners.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    image: DecorationImage(
                      image: NetworkImage(item['image']!),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['title']!,
                          style: AppStyle.smallContentRegular.copyWith(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          item['subtitle']!,
                          style: AppStyle.smallContentBold.copyWith(color: Colors.white, fontSize: 32, letterSpacing: 2),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColor.orange500,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item['discount']!,
                            style: AppStyle.smallContentBold.copyWith(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 12.0),
        Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: banners.asMap().entries.map((entry) {
            bool isSelected = controller.currentBannerIndex.value == entry.key;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isSelected ? 12.0 : 6.0,
              height: 6.0,
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99.0),
                color: isSelected ? AppColor.black500 : Colors.grey.shade300,
              ),
            );
          }).toList(),
        )),
      ],
    );
  }
}