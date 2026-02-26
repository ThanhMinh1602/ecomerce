import 'package:ecomerce/modules/app/home/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/navigationbar_widget.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => IndexedStack(
              index: controller.selectedIndex.value,
              children: [
                HomeView(),
                Container(
                  color: Colors.white,
                  child: const Center(child: Text("Cart Page")),
                ),
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
