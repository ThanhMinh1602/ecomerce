import 'package:ecomerce/core/components/quantity_selector.dart';
import 'package:ecomerce/core/extension/double_extension.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_style.dart';

class CartItemWidget extends StatelessWidget {
  final bool isSelected;
  final ValueChanged<bool?> onCheckboxChanged;
  final String imageUrl;
  final String title;
  final String variantInfo;
  final double price;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  const CartItemWidget({
    super.key,
    required this.isSelected,
    required this.onCheckboxChanged,
    required this.imageUrl,
    required this.title,
    required this.variantInfo,
    required this.price,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Checkbox(
          value: isSelected,
          onChanged: onCheckboxChanged,
          activeColor: AppColor.orange500,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          side: const BorderSide(color: AppColor.k949494, width: 1.2),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        ),
        Expanded(
          child: Dismissible(
            key: ValueKey(title + variantInfo),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => onDelete(),
            background: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE53935),
                borderRadius: BorderRadius.circular(16.0),
              ),
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 32.0,
              ),
            ),

            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: AppColor.black100.withOpacity(0.5),
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppStyle.smallContentBold.copyWith(
                            color: AppColor.black500,
                            fontSize: 16.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          variantInfo,
                          style: AppStyle.smallContentRegular.copyWith(
                            color: AppColor.k949494,
                            fontSize: 13.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            QuantitySelector(
                              quantity: quantity,
                              onIncrement: onIncrement,
                              onDecrement: onDecrement,
                            ),
                            Text(
                              price.formatPrice(),
                              style: AppStyle.smallContentBold.copyWith(
                                color: AppColor.black500,
                                fontSize: 16.0,
                              ),
                            ),


                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
