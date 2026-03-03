import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Thêm để dùng FilteringTextInputFormatter
import 'package:flutter_svg/svg.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.controller,
    required this.hintText,
    required this.labelText,
    this.isPassword = false,
    this.isNumber = false, // Thuộc tính mới [cite: 2026-03-03]
    this.maxLines = 1,      // Hỗ trợ nhập mô tả dài [cite: 2026-03-03]
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,         // Hỗ trợ search real-time [cite: 2026-03-03]
    this.onFieldSubmitted,  // Hỗ trợ thêm nhanh Size/Color [cite: 2026-03-03]
  });

  final TextEditingController? controller;
  final String hintText;
  final String labelText;
  final bool isPassword;
  final bool isNumber;
  final int maxLines;
  final String? prefixIcon;
  final String? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    showPassword = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      // Nếu là mật khẩu thì ẩn text, nếu không thì hiện bình thường
      obscureText: widget.isPassword ? showPassword : false,
      validator: widget.validator,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      // Tự động chuyển bàn phím số nếu isNumber = true [cite: 2026-03-03]
      keyboardType: widget.isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : (widget.maxLines > 1 ? TextInputType.multiline : TextInputType.text),
      // Chặn người dùng nhập chữ nếu là ô số [cite: 2026-03-03]
      inputFormatters: widget.isNumber
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
          : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: widget.labelText.isEmpty ? null : widget.labelText,
        hintText: widget.hintText,
        hintStyle: AppStyle.smallContentRegular,
        fillColor: const Color(0xFFF9FAFB),
        filled: true,
        suffixIcon: widget.suffixIcon != null
            ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.5),
          child: SvgPicture.asset(widget.suffixIcon!),
        )
            : widget.isPassword
            ? InkWell(
          onTap: () => setState(() => showPassword = !showPassword),
          child: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
        )
            : null,
        prefixIcon: widget.prefixIcon != null
            ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.5),
          child: SvgPicture.asset(widget.prefixIcon!),
        )
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.5),
        // Bo tròn 100 theo thiết kế search, hoặc 12 theo thiết kế Admin [cite: 2026-03-03]
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.maxLines > 1 ? 16.0 : 100.0),
          borderSide: BorderSide(color: AppColor.black300, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.maxLines > 1 ? 16.0 : 100.0),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.maxLines > 1 ? 16.0 : 100.0),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
        ),
      ),
    );
  }
}