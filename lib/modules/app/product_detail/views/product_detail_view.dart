import 'package:ecomerce/core/components/app_bar/small_app_bar.dart';
import 'package:ecomerce/core/components/quantity_selector.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/core/extension/double_extension.dart';
import 'package:ecomerce/modules/app/product_detail/controllers/product_detail_controller.dart';
import 'package:ecomerce/modules/app/product_detail/widgets/product_image_gallery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final product = controller.product;

    return Scaffold(
      appBar: SmallAppBar(title: 'Detail'),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        children: [
          ProductImageGallery(
            images: controller.product.images,
            heroTag: controller.heroTag,
          ),
          SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name, style: AppStyle.contentBold),
              // Trong ListView của ProductDetailView
              Obx(
                () => QuantitySelector(
                  quantity: controller.quantity.value,
                  onIncrement: () => controller.increaseQuantity(),
                  onDecrement: () => controller.decreaseQuantity(),
                ),
              ),
            ],
          ),

          SizedBox(height: 4.0),
          Row(
            spacing: 4.0,
            children: [
              Text(
                product.price.formatPrice(),
                style: AppStyle.contentBold,
              ),
              Text(
                product.oldPrice.formatPrice(),
                style: AppStyle.smallContentBold.copyWith(
                  color: AppColor.k949494,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: AppColor.k949494,
                  decorationThickness:
                      1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
