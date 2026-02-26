import 'package:ecomerce/core/components/card/custom_card.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/data/models/product_model.dart';
import 'package:ecomerce/modules/app/home/widgets/add_to_cart_button.dart';
import 'package:flutter/material.dart';

class HorizontalProductWidget extends StatelessWidget {
  const HorizontalProductWidget({super.key, this.product});
  final ProductModel? product;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.network(
              'product.mainImage',
              height: 91,
              width: 110,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 17.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  textAlign: TextAlign.left,
                  'product.title',
                  style: AppStyle.smallContentBold,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.0),
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
                SizedBox(height: 8.0),
                SizedBox(
                  height: 18.0,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return CircleAvatar(
                        radius: 9.0,
                        backgroundColor: AppColor.orange400,
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(width: 4.0),
                    itemCount: 9,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                textAlign: TextAlign.center,
                '\$${100}',
                style: AppStyle.smallContentBold,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.0),
              Text(
                textAlign: TextAlign.center,
                '\$${100}',

                style: AppStyle.smallContentSemiBold.copyWith(
                  color: AppColor.k949494,
                  fontSize: 12.0,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.0),
              AddToCartButton(),
            ],
          ),
        ],
      ),
    );
  }
}
