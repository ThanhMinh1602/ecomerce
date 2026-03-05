import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_style.dart';

class CustomMenuButton extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  // Thêm các tham số tùy chọn (có giá trị mặc định) để linh hoạt tinh chỉnh
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
    this.iconSize = 28.0, // Mặc định theo Profile
    this.fontSize = 16.0, // Mặc định theo Profile
    this.verticalPadding = 16.0, // Mặc định theo Profile
    this.borderRadius = 20.0, // Mặc định theo Profile
    this.borderOpacity = 0.8, // Mặc định theo Profile
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.0), // Bo góc cho hiệu ứng nhấn (splash)
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
            // Tự động nhận diện SVG hay PNG
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

  // Hàm helper tự động kiểm tra đuôi file
  Widget _buildIcon() {
    if (iconPath.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(iconPath, width: iconSize, height: iconSize);
    } else {
      return Image.asset(iconPath, width: iconSize, height: iconSize);
    }
  }
}