import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:ecomerce/core/components/card/custom_card.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/data/models/product_model.dart';
import 'package:ecomerce/modules/app/home/widgets/add_to_cart_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VerticalProductWidget extends StatelessWidget {
  const VerticalProductWidget({super.key, this.product});
  final ProductModel? product;

  @override
  Widget build(BuildContext context) {
    // Định dạng tiền tệ en_US để hiển thị dấu $
    final currencyFormat = NumberFormat.simpleCurrency(locale: 'en_US');

    if (product == null) return const SizedBox();

    return CustomCard(
      width: 155,
      // Padding được điều chỉnh để khớp với độ thoáng của Card trong thiết kế
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Hình ảnh sản phẩm (Khớp với hình ảnh Regular Fit shirt)
          ClipRRect(
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
          const SizedBox(height: 12.0),

          // 2. Tên sản phẩm (Ví dụ: Regular Fit shirt)
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

          // 3. Phân loại sản phẩm (Ví dụ: Men's Jacket)
          // Sử dụng categoryId hoặc mô tả ngắn để khớp với subtitle trong hình
          Text(
            product!.description, // Hoặc trường category name nếu có
            style: AppStyle.smallContentSemiBold.copyWith(
              color: AppColor.k949494,
              fontSize: 12.0,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const Spacer(),

          // 4. Giá và Nút Action [cite: 36, 37, 38]
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Giá hiện tại ($120.00) [cite: 37]
                  Text(
                    currencyFormat.format(product!.price),
                    style: AppStyle.smallContentBold.copyWith(
                      color: AppColor.black500,
                      fontSize: 15.0,
                    ),
                  ),
                  // Giá cũ gạch ngang ($150.00) [cite: 36]
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
              // Nút "+" để thêm vào giỏ hàng
              const AddToCartButton(),
            ],
          ),
        ],
      ),
    );
  }
}