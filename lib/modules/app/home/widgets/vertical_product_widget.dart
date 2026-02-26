import 'package:ecomerce/core/components/card/custom_card.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/data/models/product_model.dart';
import 'package:ecomerce/modules/app/home/widgets/add_to_cart_button.dart';
import 'package:flutter/material.dart';

class VerticalProductWidget extends StatelessWidget {
  const VerticalProductWidget({super.key, this.product});
  final ProductModel? product;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      width: 155,
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.network(
              'product.mainImage',
              height: 124,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 12.0),
          Text(
            textAlign: TextAlign.left,
            'product.title',
            style: AppStyle.smallContentBold,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 3.0),
          Text(
            textAlign: TextAlign.left,
            'product.category',
            style: AppStyle.smallContentSemiBold.copyWith(
              color: AppColor.k949494,
              fontSize: 12.0,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${100}',
                style: AppStyle.smallContentSemiBold.copyWith(
                  color: AppColor.black500,
                ),
              ),
              AddToCartButton(),
            ],
          ),
        ],
      ),
    );
  }
}
