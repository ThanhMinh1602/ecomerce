import 'package:ecomerce/core/components/animation/custom_animated_visibility.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:flutter/material.dart';

class AnimatedAuthHeader extends StatelessWidget {
  final bool isCrowded;
  final String title;
  final String subtitle;

  const AnimatedAuthHeader({
    super.key,
    required this.isCrowded,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAnimatedVisibility(
      visible: !isCrowded,
      child: Column(
        key: const ValueKey('title_texts'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyle.titleBold),
          const SizedBox(height: 8.0),
          Text(
            subtitle,
            style: AppStyle.smallContentRegular.copyWith(color: AppColor.black200),
          ),
          const SizedBox(height: 40.0),
        ],
      ),
    );
  }
}