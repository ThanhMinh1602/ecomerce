import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_style.dart';

class CustomMenuButton extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  
  final double iconSize;
  final double fontSize;
  final double verticalPadding;
  final double borderRadius;
  final double borderOpacity;

  const CustomMenuButton({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
    this.iconSize = 28.0, 
    this.fontSize = 16.0, 
    this.verticalPadding = 16.0, 
    this.borderRadius = 20.0, 
    this.borderOpacity = 0.8, 
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.0), 
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: verticalPadding),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: AppColor.black100.withOpacity(borderOpacity),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            
            _buildIcon(),

            const SizedBox(width: 16.0),

            Expanded(
              child: Text(
                title,
                style: AppStyle.smallContentBold.copyWith(
                  color: AppColor.black500,
                  fontSize: fontSize,
                ),
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: AppColor.black300,
              size: 28.0,
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildIcon() {
    if (iconPath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(iconPath, width: iconSize, height: iconSize);
    } else {
      return Image.asset(iconPath, width: iconSize, height: iconSize);
    }
  }
}