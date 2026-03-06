import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_style.dart';

class PaymentMethodItemWidget extends StatelessWidget {
  final bool isSelected;
  final String title;
  final List<String> icons; // Truyền icon Visa/MasterCard hoặc ApplePay vào đây
  final VoidCallback onTap;

  const PaymentMethodItemWidget({
    super.key,
    required this.isSelected,
    required this.title,
    required this.icons,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Mã màu xanh lá như trong thiết kế
    const Color activeGreen = Color(0xFF4CAF50);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          // Nền xanh nhạt nếu được chọn, ngược lại nền trắng
          color: isSelected ? activeGreen.withOpacity(0.08) : AppColor.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isSelected ? activeGreen.withOpacity(0.5) : AppColor.black100.withOpacity(0.5),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            // Vòng tròn Check
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? activeGreen : AppColor.white,
                border: Border.all(
                  color: isSelected ? activeGreen : AppColor.black200,
                  width: 1.0,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: AppColor.white)
                  : null,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                title,
                style: AppStyle.smallContentBold.copyWith(
                  color: isSelected ? activeGreen : AppColor.black500,
                  fontSize: 14.0,
                ),
              ),
            ),
            ...icons.map((e)=>Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Image.asset(e, width: 32.0),
            ))
          ],
        ),
      ),
    );
  }
}