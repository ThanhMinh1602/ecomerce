import 'package:ecomerce/core/constants/app_asset.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    this.controller,
    required this.hintText,
    required this.labelText,
    this.isPassword = false,
    this.prefixIcon,
  });
  final TextEditingController? controller;
  final String hintText;
  final String labelText;
  final bool isPassword;
  final String? prefixIcon;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.labelText, style: AppStyle.smallContentBold),
        SizedBox(height: 8.0),
      ],
    );
  }
}
