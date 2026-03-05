import 'package:ecomerce/core/extension/double_extension.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_style.dart';
import '../../../../data/models/cart_model.dart';

class OrderItemsSectionWidget extends StatelessWidget {
  final List<CartItemModel> items;

  const OrderItemsSectionWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Items', style: AppStyle.smallContentBold),
        const SizedBox(height: 16),

        for (int i = 0; i < items.length; i++) ...[
          _buildSingleItem(items[i]),

          if (i < items.length - 1)
            const Divider(color: AppColor.black100, thickness: 1, height: 32.0),
        ],
      ],
    );
  }

  Widget _buildSingleItem(CartItemModel item) {
    List<String> textParts = [];
    if (item.selectedSize != null && item.selectedSize!.isNotEmpty) {
      textParts.add('Size ${item.selectedSize}');
    }
    textParts.add('Qty: ${item.quantity}');
    String variantText = textParts.join(', ');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
              const SizedBox(height: 6.0),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (item.selectedColor != null &&
                      item.selectedColor!.isNotEmpty) ...[
                    _buildColorDot(item.selectedColor!),
                    const SizedBox(width: 8.0),
                  ],

                  Expanded(
                    child: Text(
                      variantText,
                      style: AppStyle.smallContentRegular.copyWith(
                        color: AppColor.k949494,
                        fontSize: 13.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Text(
          (item.price * item.quantity).formatPrice(),
          style: AppStyle.smallContentBold.copyWith(
            color: AppColor.black500,
            fontSize: 15.0,
          ),
        ),
      ],
    );
  }

  Widget _buildColorDot(String colorHex) {
    Color color;
    try {
      color = Color(int.parse(colorHex));
    } catch (e) {
      color = Colors.grey;
    }

    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black.withOpacity(0.1), width: 0.5),
      ),
    );
  }
}
