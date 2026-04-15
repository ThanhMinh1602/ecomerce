import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:ecomerce/core/components/card/custom_card.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/data/models/product_model.dart';
import 'package:ecomerce/modules/app/home/controllers/home_controller.dart';
import 'package:ecomerce/modules/app/home/widgets/add_to_cart_button.dart';
import 'package:ecomerce/modules/app/product_detail/controllers/product_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:ecomerce/data/models/cart_model.dart';
import 'package:ecomerce/data/services/cart_service.dart';

enum VerticalProductType { home, detail }

class VerticalProductWidget extends StatelessWidget {
  const VerticalProductWidget({
    super.key,
    this.product,
    this.heroTagPrefix = 'vertical_',
    this.type = VerticalProductType.home,
  });

  final ProductModel? product;
  final String heroTagPrefix;
  final VerticalProductType type;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency(locale: 'en_US');

    if (product == null) return const SizedBox();

    return GestureDetector(
      onTap: () {
        if (type == VerticalProductType.home) {
          Get.find<HomeController>().onTapProductDetail(
            product!,
            heroTagPrefix,
          );
        } else if (type == VerticalProductType.detail) {
          Get.find<ProductDetailController>().loadNewProduct(
            product!,
            'propose_${product!.id}',
          );
        }
      },
      child: CustomCard(
        width: 155,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: '$heroTagPrefix${product!.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: product!.images.isNotEmpty
                    ? CldImageWidget(
                        publicId: product!.images.first,
                        height: 124,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 124,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
              ),
            ),
            const SizedBox(height: 12.0),

            Text(
              product!.name,
              style: AppStyle.smallContentBold.copyWith(
                color: AppColor.black500,
                fontSize: 14.0,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4.0),
            Text(
              product!.categoryId,
              style: AppStyle.smallContentSemiBold.copyWith(
                color: AppColor.k949494,
                fontSize: 12.0,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currencyFormat.format(product!.price),
                      style: AppStyle.smallContentBold.copyWith(
                        color: AppColor.black500,
                        fontSize: 15.0,
                      ),
                    ),

                    if (product!.oldPrice != null && product!.oldPrice! > 0)
                      Text(
                        currencyFormat.format(product!.oldPrice),
                        style: const TextStyle(
                          color: AppColor.k949494,
                          fontSize: 11.0,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),

                AddToCartButton(
                  onTap: () async {
                    try {
                      final cartItem = CartItemModel(
                        id: '',
                        productId: product!.id,
                        name: product!.name,
                        image: product!.images.isNotEmpty
                            ? product!.images.first
                            : '',
                        price: product!.price,
                        quantity: 1,
                        selectedColor: product!.colors.isNotEmpty
                            ? product!.colors.first
                            : null,
                        availableColors: product!.colors,
                        selectedSize: null,
                        availableSizes: [],
                      );

                      await Get.find<CartService>().addToCart(cartItem);

                      Get.snackbar(
                        'Thành công',
                        'Đã thêm ${product!.name} vào giỏ hàng!',
                        backgroundColor: Colors.green.shade600,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 2),
                        margin: const EdgeInsets.all(16),
                      );
                    } catch (e) {
                      Get.snackbar(
                        'Lỗi',
                        'Không thể thêm vào giỏ hàng.',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
