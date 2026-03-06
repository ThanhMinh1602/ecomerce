import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.labelText,
    this.isPassword = false,
    this.isNumber = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String hintText;
  final String? labelText;
  final bool isPassword;
  final bool isNumber;
  final int maxLines;

  // 1. ĐỔI SANG DYNAMIC ĐỂ NHẬN ĐƯỢC CẢ STRING LẪN ICONDATA
  final dynamic prefixIcon;
  final dynamic suffixIcon;

  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTap;
  final bool readOnly;
  final bool autofocus;

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

  // --- HÀM XỬ LÝ ICON THÔNG MINH ---
  Widget? _buildIcon(dynamic iconData) {
    if (iconData == null) return null;

    if (iconData is String) {
      // Nếu là String -> Render SVG
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.5),
        child: SvgPicture.asset(iconData),
      );
    } else if (iconData is IconData) {
      // Nếu là IconData -> Render Icon của Flutter
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.5),
        child: Icon(
          iconData,
          color: AppColor.black500, // Bạn có thể tùy chỉnh màu mặc định ở đây
          size: 24, // Size tương đương với SVG
        ),
      );
    }
    return null; // Đề phòng truyền sai kiểu
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? showPassword : false,
      validator: widget.validator,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      onFieldSubmitted: widget.onFieldSubmitted,
      autofocus: widget.autofocus,
      keyboardType: widget.isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : (widget.maxLines > 1
          ? TextInputType.multiline
          : TextInputType.text),
      inputFormatters: widget.isNumber
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
          : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: AppStyle.smallContentRegular,
        fillColor: const Color(0xffffffff),
        filled: true,

        // 2. GỌI HÀM RENDER ICON CHO PREFIX
        prefixIcon: _buildIcon(widget.prefixIcon),

        // 3. GỌI HÀM RENDER ICON CHO SUFFIX (Kết hợp với logic Password)
        suffixIcon: widget.suffixIcon != null
            ? _buildIcon(widget.suffixIcon)
            : widget.isPassword
            ? InkWell(
          onTap: () => setState(() => showPassword = !showPassword),
          child: Icon(
            showPassword ? Icons.visibility_off : Icons.visibility,
            color: AppColor.k949494,
          ),
        )
            : null,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 15.5,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.maxLines > 1 ? 16.0 : 100.0,
          ),
          borderSide: BorderSide(color: AppColor.black300, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.maxLines > 1 ? 16.0 : 100.0,
          ),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            widget.maxLines > 1 ? 16.0 : 100.0,
          ),
          borderSide: const BorderSide(color: AppColor.black500, width: 1.5),
        ),
      ),
    );
  }
}