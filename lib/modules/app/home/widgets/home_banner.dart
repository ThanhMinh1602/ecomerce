import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/modules/app/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeBanner extends GetView<HomeController> {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
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
      },
      {
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