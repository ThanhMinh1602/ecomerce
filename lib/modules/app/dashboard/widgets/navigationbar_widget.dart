import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_asset.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_style.dart';
import '../controllers/dashboard_controller.dart';

class NavigationBarWidget extends GetView<DashboardController> {
  const NavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),

      decoration: BoxDecoration(borderRadius: BorderRadius.circular(99)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(99),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: AppColor.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: AppColor.kBbbbbb, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  AppAsset.home05,
                  AppAsset.home05Active,
                  0,
                  'Home',
                ),
                _buildNavItem(
                  AppAsset.shoppingCart01,
                  AppAsset.shoppingCart01Active,
                  1,
                  'Cart',
                ),
                _buildNavItem(
                  AppAsset.bell03,
                  AppAsset.bell03Active,
                  2,
                  'Noti',
                ),
                _buildNavItem(
                  AppAsset.user03,
                  AppAsset.user03Active,
                  3,
                  'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    String inactiveIcon,
    String activeIcon,
    int index,
    String label,
  ) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => controller.changeTabIndex(index),
      child: Obx(() {
        final isSelected = controller.selectedIndex.value == index;

        final int badgeCount = index == 1 ? controller.cartItemCount : 0;

        return SizedBox(
          width: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: SvgPicture.asset(
                      isSelected ? activeIcon : inactiveIcon,
                      key: ValueKey(isSelected),
                      width: 24.0,
                      height: 24.0,
                      colorFilter: const ColorFilter.mode(
                        AppColor.black500,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),

                  if (badgeCount > 0)
                    Positioned(
                      top: -6,
                      right: -8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE53935),
                          shape: BoxShape.circle,
                        ),

                        child: Text(
                          badgeCount > 99 ? '99+' : badgeCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),

              if (isSelected) ...[
                const SizedBox(height: 10),
                Text(
                  label,
                  style: AppStyle.smallContentBold.copyWith(
                    fontSize: 12.0,
                    color: AppColor.black500,
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}
