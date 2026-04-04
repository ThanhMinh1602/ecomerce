import 'package:ecomerce/data/enums/order_status.dart';
import 'package:ecomerce/modules/app/profile/controllers/profile_controller.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyOrdersCard extends StatelessWidget {
  const MyOrdersCard({super.key});

  static const Color textBrown = Color(0xFF4A2B1D);
  static const Color bgOrangeLight = Color(0xFFFFF0E5);

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: bgOrangeLight,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Track Order',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: textBrown,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tab Pending (Index 0)
              Obx(() => _buildTrackItem(
                  Icons.inventory_2_outlined,
                  OrderStatus.pending.title,
                  controller.pendingCount.value,
                  onTap: () => Get.toNamed(AppRouter.myOrders, arguments: 0)
              )),

              // Tab Processing (Index 1)
              Obx(() => _buildTrackItem(
                  Icons.inbox_outlined,
                  OrderStatus.processing.title,
                  controller.processingCount.value,
                  onTap: () => Get.toNamed(AppRouter.myOrders, arguments: 1)
              )),

              // Tab Shipped (Index 2)
              Obx(() => _buildTrackItem(
                  Icons.local_shipping_outlined,
                  OrderStatus.shipped.title,
                  controller.shippedCount.value,
                  onTap: () => Get.toNamed(AppRouter.myOrders, arguments: 2)
              )),

              // Tab Delivered (Index 3)
              Obx(() => _buildTrackItem(
                  Icons.star_border_outlined,
                  OrderStatus.delivered.title,
                  controller.deliveredCount.value,
                  onTap: () => Get.toNamed(AppRouter.myOrders, arguments: 3)
              )),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildTrackItem(IconData icon, String label, int badgeCount, {required VoidCallback onTap}) {
    return GestureDetector( // Thêm GestureDetector để bắt sự kiện click
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 54, height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7A00),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: const Color(0xFFFF7A00).withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6)),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              if (badgeCount > 0)
                Positioned(
                  top: -4, right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Color(0xFFE53935), shape: BoxShape.circle),
                    child: Text('$badgeCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: textBrown, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }


}