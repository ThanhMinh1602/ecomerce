import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/modules/app/home/controllers/home_controller.dart';
import 'package:ecomerce/modules/app/home/widgets/horizontal_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeComboList extends GetView<HomeController> {
  const HomeComboList({super.key});

  @override
  Widget build(BuildContext context) {
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
}