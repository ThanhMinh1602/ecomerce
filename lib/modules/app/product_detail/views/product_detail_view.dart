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
      // 1. Bọc body bằng Obx để theo dõi currentProduct
      body: Obx(() => _buildBody(controller.currentProduct.value)),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBody(ProductModel product) {
    return ListView(
      // 2. Gắn ScrollController vào ListView
      controller: controller.scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      children: [
        ProductImageGallery(
          images: product.images,
          // 3. Truyền heroTag động từ controller
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
        ColorDotList(
          colors: product.colors,
          size: 22.0,
          spacing: 4.0,
          limit: product.colors.length,
        ),
        const SizedBox(height: 12.0),
        ProductSizeAndRating(sizes: product.sizes, rating: product.rating),
        const SizedBox(height: 24),
        ProductDescriptionTile(description: product.description),
        const SizedBox(height: 24),
        const ProductReviewList(),
        const ProductProposeList(),
      ],
    );
  }

  // Tách bottom bar ra cho sạch sẽ
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
              onPressed: () => controller.addToCart(), // Đã gắn hàm
            ),
          ),
          Expanded(
            child: CustomButton(
                btnText: 'Buy Now',
                onPressed: () {}
            ),
          ),
        ],
      ),
    );
  }
}