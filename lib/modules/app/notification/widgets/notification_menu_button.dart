import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_style.dart';

class NotificationMenuButton extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  const NotificationMenuButton({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: AppColor.black100, width: 1.0),
        ),
        child: Row(
          children: [
            Image.asset(iconPath, width: 39),
            const SizedBox(width: 16.0),
            Expanded(
              child: Text(
                title,
                style: AppStyle.smallContentBold.copyWith(
                  color: AppColor.black500,
                  fontSize: 18.0,
                ),
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              color: AppColor.black300,
              size: 28.0,
            ),
          ],
        ),
      ),
    );
  }
}
