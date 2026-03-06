import 'package:ecomerce/core/components/app_bar/small_app_bar.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_style.dart';

class MyOrdersView extends StatelessWidget {
  const MyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // 4 trạng thái đơn hàng
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: SmallAppBar(
          title: 'My Orders',
        ),
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
                  _buildOrderList(), // Gọi list cho từng tab
                  _buildOrderList(),
                  _buildOrderList(),
                  _buildOrderList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Danh sách các thẻ đơn hàng
  Widget _buildOrderList() {
    return ListView.separated(
      padding: const EdgeInsets.all(24.0),
      itemCount: 3, // Giả lập 3 đơn hàng
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
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
                  Text('Order #ORD-2026${index}306', style: AppStyle.smallContentBold),
                  Text('Mar 06, 2026', style: AppStyle.smallContentRegular.copyWith(color: AppColor.k949494)),
                ],
              ),
              const Divider(height: 24, color: AppColor.black100),

              // Giả lập hiển thị số lượng sản phẩm (bạn có thể tái sử dụng OrderItemsSectionWidget ở đây nếu muốn show chi tiết)
              Text('2 Items', style: AppStyle.smallContentRegular),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Amount', style: AppStyle.smallContentRegular.copyWith(color: AppColor.k949494)),
                  Text('\$120.00', style: AppStyle.smallContentBold.copyWith(color: AppColor.orange500, fontSize: 16.0)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}