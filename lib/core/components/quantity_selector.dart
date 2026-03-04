import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 98,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildButton(
            icon: Icons.remove,
            bgColor: AppColor.white,
            onTap: onDecrement,
          ),

          Text(
            quantity.toString().padLeft(2, '0'),
            style: AppStyle.smallContentBold.copyWith(fontSize: 14),
          ),

          _buildButton(
            icon: Icons.add,
            bgColor: AppColor.orange500,
            onTap: onIncrement,
            iconColor: AppColor.white,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required Color bgColor,
    required VoidCallback onTap,
    Color iconColor = AppColor.black500,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        child: Center(child: Icon(icon, size: 18, color: iconColor)),
      ),
    );
  }
}
