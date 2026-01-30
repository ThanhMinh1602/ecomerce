import 'package:ecomerce/modules/home/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Import các view của bạn ở đây
// import '../../home/views/home_view.dart';
// import '../../cart/views/cart_view.dart'; etc.

import '../widgets/navigationbar_widget.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Sử dụng Obx để lắng nghe thay đổi index
          Obx(
            () => IndexedStack(
              index: controller.selectedIndex.value,
              children: [
                HomeView(), // Thay bằng HomeView()
                Container(
                  color: Colors.white,
                  child: const Center(child: Text("Cart Page")),
                ), // Thay bằng CartView()
                Container(
                  color: Colors.white,
                  child: const Center(child: Text("Notifications")),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(child: Text("Profile Page")),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 38,
            left: 16.0,
            right: 16.0,
            child: const NavigationBarWidget(),
          ),
        ],
      ),
    );
  }
}
