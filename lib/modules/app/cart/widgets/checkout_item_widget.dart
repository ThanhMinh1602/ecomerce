import 'package:ecomerce/core/extension/double_extension.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_style.dart';
import '../../../../data/models/cart_model.dart'; // Import Model của bạn

class CheckoutItemWidget extends StatelessWidget {
  final CartItemModel item;

  const CheckoutItemWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    // Gom Color và Size lại để hiển thị cho gọn
    List<String> parts = [];
    if (item.selectedColor != null && item.selectedColor!.isNotEmpty) {
      parts.add(item.selectedColor!);
    }
    if (item.selectedSize != null && item.selectedSize!.isNotEmpty) {
      parts.add('Size ${item.selectedSize}');
    }
    String variantInfo = parts.join(', ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0), // Khoảng cách giữa các món đồ
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Hình ảnh thu nhỏ
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.network(
              item.image,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 64,
                height: 64,
                color: Colors.grey[200],
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12.0),

          // 2. Thông tin sản phẩm (Tên, Phân loại, Số lượng)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppStyle.smallContentBold.copyWith(
                    color: AppColor.black500,
                    fontSize: 15.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  variantInfo.isEmpty ? 'Qty: ${item.quantity}' : '$variantInfo, x${item.quantity}',
                  style: AppStyle.smallContentRegular.copyWith(
                    color: AppColor.k949494,
                    fontSize: 13.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12.0),

          // 3. Tổng giá của riêng item đó (giá gốc x số lượng)
          Text(
            (item.price * item.quantity).formatPrice(),
            style: AppStyle.smallContentBold.copyWith(
              color: AppColor.black500,
              fontSize: 15.0,
            ),
          ),
        ],
      ),
    );
  }
}