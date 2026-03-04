import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:ecomerce/core/components/card/custom_card.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/data/models/product_model.dart';
import 'package:ecomerce/modules/app/home/controllers/home_controller.dart';
import 'package:ecomerce/modules/app/home/widgets/add_to_cart_button.dart';
import 'package:ecomerce/modules/app/product_detail/controllers/product_detail_controller.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VerticalProductWidget extends StatelessWidget {
  const VerticalProductWidget({
    super.key,
    this.product,
    this.heroTagPrefix = 'vertical_',
  });

  final ProductModel? product;
  final String heroTagPrefix;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency(locale: 'en_US');

    if (product == null) return const SizedBox();

    return GestureDetector(
      onTap: () => Get.find<HomeController>().onTapProductDetail(product!, heroTagPrefix),
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
                    ?
                CldImageWidget(
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
                        style: TextStyle(
                          color: AppColor.k949494,
                          fontSize: 11.0,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),

                const AddToCartButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
