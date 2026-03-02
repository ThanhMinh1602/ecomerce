import 'package:ecomerce/core/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    this.icon,
    required this.btnText,
  });

  final void Function()? onPressed;
  final String? icon;
  final String btnText;

  @override
  Widget build(BuildContext context) {
    final bool isActive = onPressed != null;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 55.0),

        backgroundColor: AppColor.orange500,
        disabledBackgroundColor: Colors.white,
        elevation: 0,

        side: isActive
            ? BorderSide.none
            : BorderSide(color: Colors.grey.shade300, width: 1.5),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10.0,
        children: [
          Text(
            btnText,
            style: GoogleFonts.robotoSerif(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,

              color: isActive ? Colors.white : Colors.grey.shade400,
            ),
          ),
          if (icon != null)
            SvgPicture.asset(
              icon!,

              colorFilter: ColorFilter.mode(
                isActive ? Colors.white : Colors.grey.shade400,
                BlendMode.srcIn,
              ),
            ),
        ],
      ),
    );
  }
}
