import 'package:ecomerce/core/components/text_field/custom_text_field.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    this.controller,
    required this.hintText,
    required this.labelText,
    this.isPassword = false,
    this.prefixIcon,
    this.validator,
  });
  final TextEditingController? controller;
  final String hintText;
  final String labelText;
  final bool isPassword;
  final String? prefixIcon;
  final String? Function(String?)? validator;

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
        CustomTextField(
          controller: widget.controller,
          hintText: widget.hintText,
          isPassword: widget.isPassword,
          prefixIcon: widget.prefixIcon,
          validator: widget.validator,
        ),
      ],
    );
  }
}
