import 'package:flutter/material.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_style.dart';

class EmptyAddressWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;

  const EmptyAddressWidget({
    super.key,
    required this.onTap,
    this.title = 'Add delivery address',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Delivery information', style: AppStyle.smallContentBold),
        const SizedBox(height: 12.0),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: AppColor.orange500.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(
                color: AppColor.orange500.withOpacity(0.5),
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_location_alt_outlined,
                  color: AppColor.orange500,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: AppStyle.smallContentBold.copyWith(
                    color: AppColor.orange500,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
