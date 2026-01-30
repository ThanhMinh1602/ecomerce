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
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 55.0),
        backgroundColor: AppColor.orange500,
        elevation: 0,
      ),
      child: Row(
        spacing: 10.0,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            btnText,
            style: GoogleFonts.robotoSerif(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          if (icon != null) SvgPicture.asset(icon!, color: Colors.white),
        ],
      ),
    );
  }
}
