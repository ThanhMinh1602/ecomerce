import 'package:ecomerce/core/components/category_item.dart';
import 'package:ecomerce/core/constants/app_asset.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductSizeAndRating extends StatelessWidget {
  final List<String> sizes;
  final double rating;

  const ProductSizeAndRating({
    super.key,
    required this.sizes,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Wrap(
            spacing: 4.0,
            runSpacing: 4.0,
            children: sizes.map((size) => CategoryItem(
              title: size,
              textStyle: AppStyle.smallContentBold,
              isSelected: false, 
              onTap: () {},
            )).toList(),
          ),
        ),
        const SizedBox(width: 12.0),
        _buildRatingBadge(),
      ],
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.k949494, width: 0.5),
        borderRadius: BorderRadius.circular(33.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(AppAsset.star01),
          const SizedBox(width: 4.0),
          Text(rating.toString(), style: AppStyle.smallContentBold),
        ],
      ),
    );
  }
}