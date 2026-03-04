import 'package:ecomerce/core/constants/app_asset.dart'; // Đảm bảo đúng đường dẫn asset
import 'package:ecomerce/core/components/text_field/custom_text_field.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: 'Enter the item you want to search for.',
      prefixIcon: AppAsset.search,
      suffixIcon: AppAsset.camera,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      readOnly: readOnly,
      autofocus: autofocus,
    );
  }
}
