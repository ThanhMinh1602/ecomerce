import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';
import '../controllers/dashboard_controller.dart';

class NavigationBarWidget extends GetView<DashboardController> {
  const NavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
        child: Container(
          height: 71,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            color: AppColor.kFFF1E8.withOpacity(0.8),
          ),
          child: Row(
            children: [
              _buildNavItem(Icons.home, 0),
              _buildNavItem(Icons.shopping_cart, 1),
              _buildNavItem(Icons.notifications, 2),
              _buildNavItem(Icons.person, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return Expanded(
      child: InkWell(
        onTap: () => controller.changeTabIndex(index),
        child: Obx(() {
          final isSelected = controller.selectedIndex.value == index;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24.0,
                color: isSelected ? Colors.orange : Colors.grey,
              ),
              if (isSelected)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  height: 4,
                  width: 4,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
