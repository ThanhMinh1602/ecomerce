import 'package:flutter/material.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_style.dart';

class DiscountSelectorWidget extends StatelessWidget {
  final String? selectedDiscountCode; // Truyền vào nếu đã áp dụng mã
  final VoidCallback onTap;

  const DiscountSelectorWidget({
    super.key,
    this.selectedDiscountCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99.0), // Viền bo tròn dạng viên thuốc
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(99.0),
          border: Border.all(color: AppColor.black100.withOpacity(0.5), width: 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Discount code',
              style: AppStyle.smallContentBold.copyWith(color: AppColor.black500),
            ),

            Row(
              children: [
                Text(
                  selectedDiscountCode ?? 'Select discount code',
                  style: AppStyle.smallContentRegular.copyWith(
                    // Nếu đã có mã thì in đậm màu đen, chưa có thì xám
                    color: selectedDiscountCode != null ? AppColor.black500 : AppColor.k949494,
                    fontWeight: selectedDiscountCode != null ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 8.0),
                const Icon(Icons.chevron_right_rounded, color: AppColor.k949494, size: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}