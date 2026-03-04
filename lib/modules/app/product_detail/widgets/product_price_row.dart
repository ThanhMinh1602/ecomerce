import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/core/extension/double_extension.dart';
import 'package:flutter/material.dart';

class ProductPriceRow extends StatelessWidget {
  final double price;
  final double? oldPrice;

  const ProductPriceRow({super.key, required this.price, this.oldPrice});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(price.formatPrice(), style: AppStyle.contentBold),
        const SizedBox(width: 4.0),
        if (oldPrice != null && oldPrice! > 0)
          Text(
            oldPrice!.formatPrice(),
            style: AppStyle.smallContentBold.copyWith(
              color: AppColor.k949494,
              decoration: TextDecoration.lineThrough,
              decorationColor: AppColor.k949494,
              decorationThickness: 1.5,
            ),
          ),
      ],
    );
  }
}