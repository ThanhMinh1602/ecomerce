import 'package:ecomerce/core/components/app_bar/small_app_bar.dart';
import 'package:ecomerce/core/components/button/custom_button.dart';
import 'package:ecomerce/core/components/color_dot_list.dart' show ColorDotList;
import 'package:ecomerce/data/models/product_model.dart';
import 'package:ecomerce/modules/app/product_detail/controllers/product_detail_controller.dart';
import 'package:ecomerce/modules/app/product_detail/widgets/product_description.dart';
import 'package:ecomerce/modules/app/product_detail/widgets/product_image_gallery.dart';
import 'package:ecomerce/modules/app/product_detail/widgets/product_name_and_quantity.dart';
import 'package:ecomerce/modules/app/product_detail/widgets/product_price_row.dart';
import 'package:ecomerce/modules/app/product_detail/widgets/product_propose_list.dart';
import 'package:ecomerce/modules/app/product_detail/widgets/product_review_list.dart';
import 'package:ecomerce/modules/app/product_detail/widgets/product_size_and_rating.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SmallAppBar(title: 'Detail'),

      body: Obx(() => _buildBody(controller.currentProduct.value)),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBody(ProductModel product) {
    return ListView(
      controller: controller.scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      children: [
        ProductImageGallery(
          images: product.images,

          heroTag: controller.currentHeroTag.value,
        ),
        const SizedBox(height: 24.0),
        ProductNameAndQuantity(
          name: product.name,
          quantity: controller.quantity,
          onIncrement: controller.increaseQuantity,
          onDecrement: controller.decreaseQuantity,
        ),
        const SizedBox(height: 4.0),
        ProductPriceRow(price: product.price, oldPrice: product.oldPrice),
        const SizedBox(height: 12.0),
        Obx(
          () => ColorDotList(
            colors: controller.currentProduct.value.colors,
            selectedColor: controller.selectedColor.value, 
            onColorSelected: controller.selectColor, 
            spacing: 4,
            size: 22,
          ),
        ),
        const SizedBox(height: 12.0),
        Obx(
          () => ProductSizeAndRating(
            sizes: controller.currentProduct.value.sizes,
            rating: controller.currentProduct.value.rating,
            selectedSize: controller.selectedSize.value, 
            onSizeSelected: controller.selectSize, 
          ),
        ),
        const SizedBox(height: 24),
        ProductDescriptionTile(description: product.description),
        const SizedBox(height: 24),
        const ProductReviewList(),
        const ProductProposeList(),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      width: double.infinity,
      height: 75.0,
      child: Row(
        spacing: 16.0,
        children: [
          Expanded(
            child: CustomButton(
              btnText: 'Add to Cart',
              type: ButtonType.secondary,
              onPressed: () => controller.addToCart(),
            ),
          ),
          Expanded(
            child: CustomButton(
              btnText: 'Buy Now',
              onPressed: controller.onTapBuyNow,
            ),
          ),
        ],
      ),
    );
  }
}
