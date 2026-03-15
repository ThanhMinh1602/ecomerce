import 'package:flutter/material.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_style.dart';

class MyOrdersCard extends StatelessWidget {
  const MyOrdersCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: AppColor.black100.withOpacity(0.5),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My orders',
            style: AppStyle.smallContentBold.copyWith(
              color: AppColor.black500,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOrderIconButton(Icons.local_shipping_outlined, () {}),
              _buildOrderIconButton(Icons.local_shipping_outlined, () {}),
              _buildOrderIconButton(Icons.local_shipping_outlined, () {}),
              _buildOrderIconButton(Icons.local_shipping_outlined, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: AppColor.orange500,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColor.white, size: 26),
      ),
    );
  }
}
