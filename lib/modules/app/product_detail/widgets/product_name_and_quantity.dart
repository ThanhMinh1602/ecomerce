import 'package:ecomerce/core/components/quantity_selector.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductNameAndQuantity extends StatelessWidget {
  final String name;
  final RxInt quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ProductNameAndQuantity({
    super.key,
    required this.name,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(name, style: AppStyle.contentBold),
        ),
        Obx(
              () => QuantitySelector(
            quantity: quantity.value,
            onIncrement: onIncrement,
            onDecrement: onDecrement,
          ),
        ),
      ],
    );
  }
}