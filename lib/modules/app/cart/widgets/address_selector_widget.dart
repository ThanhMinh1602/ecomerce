import 'package:flutter/material.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_style.dart';

class AddressSelectorWidget extends StatelessWidget {
  final String name;
  final String phone;
  final String address;
  final VoidCallback onTap;

  const AddressSelectorWidget({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Delivery information', style: AppStyle.smallContentBold),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(color: AppColor.black100.withOpacity(0.5), width: 1.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const Icon(Icons.location_on, color: AppColor.black500, size: 28),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: AppStyle.smallContentBold.copyWith(color: AppColor.black500),
                          children: [
                            TextSpan(text: name),
                            TextSpan(
                              text: ' ($phone)',
                              style: AppStyle.smallContentRegular.copyWith(color: AppColor.k949494),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        address,
                        style: AppStyle.smallContentRegular.copyWith(color: AppColor.k949494),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColor.black500, size: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}