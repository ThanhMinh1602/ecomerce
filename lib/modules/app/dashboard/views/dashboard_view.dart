import 'package:ecomerce/modules/app/home/views/home_view.dart';
import 'package:ecomerce/modules/app/notification/views/notification_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/navigationbar_widget.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Obx(
            () => IndexedStack(
          index: controller.selectedIndex.value,
          children: [
            HomeView(),
            Container(
              color: Colors.white,
              child: const Center(child: Text("Cart Page")),
            ),
            NotificationView(
            ),
            Container(
              color: Colors.white,
              child: const Center(child: Text("Profile Page")),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavigationBarWidget(),
    );
  }
}
