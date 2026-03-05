import 'package:flutter/material.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_style.dart';

class DiscountSelectorWidget extends StatelessWidget {
  final String? selectedDiscountCode;
  final VoidCallback onTap;

  const DiscountSelectorWidget({
    super.key,
    this.selectedDiscountCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Discount & Vouchers', style: AppStyle.smallContentBold),
        const SizedBox(height: 12),

        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 14.0,
            ),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: selectedDiscountCode != null
                    ? AppColor.orange500
                    : AppColor.black100.withOpacity(0.5),
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_offer_outlined,
                      color: selectedDiscountCode != null
                          ? AppColor.orange500
                          : AppColor.black500,
                      size: 20,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      'Promo code',
                      style: AppStyle.smallContentBold.copyWith(
                        color: AppColor.black500,
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Text(
                      selectedDiscountCode ?? 'Select code',
                      style: AppStyle.smallContentRegular.copyWith(
                        color: selectedDiscountCode != null
                            ? AppColor.orange500
                            : AppColor.k949494,
                        fontWeight: selectedDiscountCode != null
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: selectedDiscountCode != null
                          ? AppColor.orange500
                          : AppColor.k949494,
                      size: 24,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
