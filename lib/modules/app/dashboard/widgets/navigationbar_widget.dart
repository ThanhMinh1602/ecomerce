import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';
import '../controllers/dashboard_controller.dart';

class NavigationBarWidget extends GetView<DashboardController> {
  const NavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            height: 71,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              
              color: Colors.white.withOpacity(0.1),
              
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildNavItem(Icons.home_outlined, Icons.home, 0),
                _buildNavItem(Icons.shopping_cart_outlined, Icons.shopping_cart, 1),
                _buildNavItem(Icons.notifications_outlined, Icons.notifications, 2),
                _buildNavItem(Icons.person_outline, Icons.person, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData inactiveIcon, IconData activeIcon, int index) {
    return Expanded(
      child: InkWell(
        
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => controller.changeTabIndex(index),
        child: Obx(() {
          final isSelected = controller.selectedIndex.value == index;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  isSelected ? activeIcon : inactiveIcon,
                  size: 26.0,
                  color: isSelected ? Colors.orange : Colors.white.withOpacity(0.6),
                ),
              ),
              if (isSelected)
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  height: 5,
                  width: 5,
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