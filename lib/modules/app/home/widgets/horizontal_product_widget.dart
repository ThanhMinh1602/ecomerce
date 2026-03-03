import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:ecomerce/core/components/card/custom_card.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/data/models/product_model.dart';
import 'package:ecomerce/modules/app/home/widgets/add_to_cart_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HorizontalProductWidget extends StatelessWidget {
  const HorizontalProductWidget({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    // Sử dụng locale en_US để hiển thị ký tự $ giống thiết kế [cite: 37, 38]
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'en_US');

    return CustomCard(
      // Giảm padding để card trông gọn gàng hơn
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
      child: Row(
        children: [
          // 1. Hình ảnh chính (Góc bo tròn 16.0)
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: product.images.isNotEmpty
                ? CldImageWidget(
              publicId: product.images.first,
              height: 91,
              width: 110,
              fit: BoxFit.cover,
            )
                : Container(
              width: 110,
              height: 91,
              color: Colors.grey[200],
              child: const Icon(Icons.image, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 17.0),

          // 2. Nội dung text (Căn trái)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tên sản phẩm (Ví dụ: Korean style Men's Combo)
                Text(
                  product.name,
                  style: AppStyle.smallContentBold.copyWith(
                    fontSize: 14.0,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                // Mô tả/Thương hiệu (Ví dụ: NEEDARNA 7 FASHION TRENDS)
                Text(
                  product.description,
                  style: AppStyle.smallContentSemiBold.copyWith(
                    color: AppColor.k949494,
                    fontSize: 12.0,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // 3. Giá tiền và Nút thêm (+) [cite: 37, 38, 39]
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Giá hiện tại ($120.00) [cite: 37]
              Text(
                formatCurrency.format(product.price),
                style: AppStyle.smallContentBold.copyWith(
                  color: Colors.black, // Hoặc AppColor.orange500 tùy ý thích của bạn
                  fontSize: 15.0,
                ),
              ),
              // Giá cũ gạch ngang ($150.00) [cite: 38]
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
              // Nút "+" đặc trưng [cite: 39]
              const AddToCartButton(),
            ],
          ),
        ],
      ),
    );
  }
}