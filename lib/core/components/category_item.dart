import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.padding,   
    this.textStyle, 
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.orange500 : AppColor.white,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: AppColor.k949494),
        ),
        child: Text(
          title,
          style: (textStyle ?? AppStyle.smallContentBold).copyWith(
            color: isSelected ? AppColor.white : AppColor.black500,
          ),
        ),
      ),
    );
  }
}