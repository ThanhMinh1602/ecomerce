import 'package:ecomerce/core/components/category_item.dart';
import 'package:ecomerce/core/constants/app_asset.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductSizeAndRating extends StatelessWidget {
  final List<String> sizes;
  final double rating;

  // THÊM 2 BIẾN NÀY ĐỂ NHẬN STATE VÀ SỰ KIỆN TỪ CONTROLLER
  final String selectedSize;
  final ValueChanged<String> onSizeSelected;

  const ProductSizeAndRating({
    super.key,
    required this.sizes,
    required this.rating,
    required this.selectedSize,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Wrap(
            spacing: 8.0, // Tăng khoảng cách ra một chút cho dễ bấm
            runSpacing: 8.0,
            children: sizes.map((size) => CategoryItem(
              title: size,
              textStyle: AppStyle.smallContentBold,
              isSelected: size == selectedSize, // So sánh để đổi màu cam nếu được chọn
              onTap: () => onSizeSelected(size), // Truyền tên size ra ngoài khi bấm
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
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.k949494, width: 0.5),
        borderRadius: BorderRadius.circular(33.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(AppAsset.star01, width: 16),
          const SizedBox(width: 4.0),
          Text(rating.toString(), style: AppStyle.smallContentBold),
        ],
      ),
    );
  }
}