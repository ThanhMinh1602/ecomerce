import 'package:cloudinary_flutter/image/cld_image.dart';
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
  final double price;
  final int quantity;

  final String selectedSize;
  final String selectedColor;
  final List<String> availableSizes;
  final List<String> availableColors;
  final Function(String newSize, String newColor) onVariantChanged;

  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  const CartItemWidget({
    super.key,
    required this.isSelected,
    required this.onCheckboxChanged,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.quantity,
    required this.selectedSize,
    required this.selectedColor,
    required this.availableSizes,
    required this.availableColors,
    required this.onVariantChanged,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  Color _getColorFromString(String colorHex) {
    try {
      return Color(int.parse(colorHex));
    } catch (e) {
      return Colors.grey;
    }
  }

  Widget _buildSmallDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool isColorMode = false,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();
    final safeValue = items.contains(value) ? value : items.first;

    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AppColor.k949494.withOpacity(0.4)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: safeValue,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: AppColor.black500,
          ),
          isDense: true,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          onChanged: onChanged,

          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((String itemValue) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isColorMode)
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: _getColorFromString(itemValue),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black26, width: 0.5),
                      ),
                    )
                  else
                    Text(
                      itemValue,
                      style: AppStyle.smallContentBold.copyWith(
                        color: AppColor.black500,
                        fontSize: 13.0,
                      ),
                    ),
                ],
              );
            }).toList();
          },

          items: items.map<DropdownMenuItem<String>>((String itemValue) {
            final isCurrent = safeValue == itemValue;

            return DropdownMenuItem<String>(
              value: itemValue,
              child: isColorMode
                  ? Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: _getColorFromString(itemValue),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCurrent
                              ? AppColor.orange500
                              : Colors.black26,
                          width: isCurrent ? 2.0 : 0.5,
                        ),
                      ),
                    )
                  : Text(
                      itemValue,
                      style: AppStyle.smallContentRegular.copyWith(
                        color: isCurrent
                            ? AppColor.orange500
                            : AppColor.black500,
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 14.0,
                      ),
                    ),
            );
          }).toList(),
        ),
      ),
    );
  }

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
            key: ValueKey(title + selectedSize + selectedColor),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => onDelete(),
            background: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE53935),
                borderRadius: BorderRadius.circular(16.0),
              ),
              alignment: Alignment.center,
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
                    child: CldImageWidget(
                      publicId: imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
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
                        const SizedBox(height: 8.0),

                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: [
                            if (availableSizes.isNotEmpty)
                              _buildSmallDropdown(
                                value: selectedSize,
                                items: availableSizes,
                                onChanged: (newValue) {
                                  if (newValue != null &&
                                      newValue != selectedSize) {
                                    onVariantChanged(newValue, selectedColor);
                                  }
                                },
                                isColorMode: false,
                              ),

                            if (availableColors.isNotEmpty)
                              _buildSmallDropdown(
                                value: selectedColor,
                                items: availableColors,
                                onChanged: (newValue) {
                                  if (newValue != null &&
                                      newValue != selectedColor) {
                                    onVariantChanged(selectedSize, newValue);
                                  }
                                },
                                isColorMode: true,
                              ),
                          ],
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
