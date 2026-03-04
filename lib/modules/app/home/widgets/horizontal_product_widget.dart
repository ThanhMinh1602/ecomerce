import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:ecomerce/core/components/card/custom_card.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/data/models/product_model.dart';
import 'package:ecomerce/modules/app/home/controllers/home_controller.dart';
import 'package:ecomerce/modules/app/home/widgets/add_to_cart_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HorizontalProductWidget extends StatelessWidget {
  const HorizontalProductWidget({
    super.key,
    required this.product,
    this.heroTagPrefix = 'horizontal_',
  });

  final ProductModel product;
  final String heroTagPrefix;

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'en_US');

    return GestureDetector(
      onTap: () => Get.find<HomeController>().onTapProductDetail(product, heroTagPrefix),
      child: CustomCard(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: '$heroTagPrefix${product.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: product.images.isNotEmpty
                    ?
                       CldImageWidget(
                          publicId: product.images.first,
                          height: 95,
                          width: 110,
                          fit: BoxFit.cover,
                        )

                    : Container(
                        width: 110,
                        height: 95,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
              ),
            ),
            const SizedBox(width: 16.0),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.name,
                    style: AppStyle.smallContentBold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    product.categoryId,
                    style: AppStyle.smallContentSemiBold.copyWith(
                      color: AppColor.k949494,
                      fontSize: 12.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  if (product.colors.isNotEmpty)
                    Wrap(
                      spacing: 6.0,
                      children: product.colors.take(4).map((colorHex) {
                        return Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Color(int.parse(colorHex)),
                            shape: BoxShape.circle,
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
            SizedBox(width: 12.0),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formatCurrency.format(product.price),
                  style: AppStyle.smallContentBold.copyWith(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),

                if (product.oldPrice != null && product.oldPrice! > 0)
                  Text(
                    formatCurrency.format(product.oldPrice),
                    style: AppStyle.smallContentSemiBold.copyWith(
                      color: AppColor.k949494,
                      fontSize: 11.0,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                const SizedBox(height: 8.0),

                const AddToCartButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
