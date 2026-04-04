import 'package:ecomerce/core/components/app_bar/small_app_bar.dart';
import 'package:ecomerce/data/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_style.dart';
import '../controllers/my_orders_controller.dart';

class MyOrdersView extends GetView<MyOrdersController> {
  const MyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final int initialTabIndex = Get.arguments is int ? Get.arguments as int : 0;

    return DefaultTabController(
      initialIndex: initialTabIndex,
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const SmallAppBar(title: 'My Orders'),
        body: Column(
          children: [
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: AppColor.orange500,
              labelColor: AppColor.orange500,
              unselectedLabelColor: AppColor.k949494,
              labelStyle: AppStyle.smallContentBold,
              tabs: const [
                Tab(text: 'Pending'),
                Tab(text: 'Processing'),
                Tab(text: 'Shipped'),
                Tab(text: 'Delivered'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildOrderList(controller.pendingOrders),
                  _buildOrderList(controller.processingOrders),
                  _buildOrderList(controller.shippedOrders),
                  _buildOrderList(controller.deliveredOrders),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(RxList<OrderModel> orderList) {
    return Obx(() {
      if (controller.isLoading.value && orderList.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: AppColor.orange500),
        );
      }

      if (orderList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: AppColor.k949494.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'You have no orders here',
                style: AppStyle.smallContentRegular.copyWith(
                  color: AppColor.k949494,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(24.0),
        itemCount: orderList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final order = orderList[index];

          return Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.black100.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order #${order.id.substring(0, 8).toUpperCase()}',
                      style: AppStyle.smallContentBold,
                    ),

                    Text(
                      controller.formatDate(order.createdAt),
                      style: AppStyle.smallContentRegular.copyWith(
                        color: AppColor.k949494,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24, color: AppColor.black100),

                Text(
                  '${order.items.length} Items',
                  style: AppStyle.smallContentRegular,
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                      style: AppStyle.smallContentRegular.copyWith(
                        color: AppColor.k949494,
                      ),
                    ),

                    Text(
                      '\$${order.totalAmount.toStringAsFixed(2)}',
                      style: AppStyle.smallContentBold.copyWith(
                        color: AppColor.orange500,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
