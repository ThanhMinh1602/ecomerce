import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.controller,
    required this.hintText,
    required this.labelText,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
  });
  final TextEditingController? controller;
  final String hintText;
  final String labelText;
  final bool isPassword;
  final String? prefixIcon;
  final String? suffixIcon;
  final String? Function(String?)? validator;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: showPassword,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppStyle.smallContentRegular,

        suffixIcon: widget.suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 15.5,
                ),
                child: SvgPicture.asset(widget.suffixIcon!),
              )
            : widget.isPassword
            ? InkWell(
                onTap: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 15.5,
                  ),
                  child: Icon(
                    showPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              )
            : null,
        prefixIcon: widget.prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 15.5,
                ),
                child: SvgPicture.asset(widget.prefixIcon!),
              )
            : null,

        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: BorderSide(color: AppColor.black300, width: 0.0),
        ),
      ),
    );
  }
}
