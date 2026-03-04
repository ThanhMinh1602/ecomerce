import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

enum ButtonType { primary, secondary }

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    this.icon,
    required this.btnText,
    this.type = ButtonType.primary,
  });

  final void Function()? onPressed;
  final String? icon;
  final String btnText;
  final ButtonType type;

  @override
  Widget build(BuildContext context) {
    final bool isActive = onPressed != null;

    final Color bgColor = type == ButtonType.primary
        ? AppColor.orange500
        : AppColor.white;
    final Color contentColor = type == ButtonType.primary
        ? AppColor.white
        : AppColor.black500;
    final BorderSide borderSide = type == ButtonType.primary
        ? BorderSide.none
        : const BorderSide(color: AppColor.black500, width: 1.5);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 55.0),

        backgroundColor: bgColor,
        disabledBackgroundColor: Colors.white,
        elevation: 0,

        side: isActive
            ? borderSide
            : BorderSide(color: Colors.grey.shade300, width: 1.5),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(99.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10.0,
        children: [
          Text(
            btnText,
            style: AppStyle.smallContentBold.copyWith(
              color: isActive ? contentColor : Colors.grey.shade400,
            ),
          ),
          if (icon != null)
            SvgPicture.asset(
              icon!,
              colorFilter: ColorFilter.mode(
                isActive ? contentColor : Colors.grey.shade400,
                BlendMode.srcIn,
              ),
            ),
        ],
      ),
    );
  }
}
