import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/data/enums/notification_type.dart';
import 'package:flutter/material.dart';
import 'notification_item.dart'; // Import file item vừa tạo

class NotificationListView extends StatelessWidget {
  const NotificationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('All notification', style: AppStyle.smallContentBold),
                Text('Readmore', style: AppStyle.smallContentBold.copyWith(
                    decorationStyle: TextDecorationStyle.solid,
                    decoration: TextDecoration.underline,
                )),
              ]),
          const SizedBox(height: 16.0),
          ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              // Type 1: Đơn hàng (Có bôi cam mã vận đơn)
              NotificationItem(
                type: NotificationType.order,
                title: 'Package delivered successfully',
                message: 'Package X92929292T has been successfully delivered to you.',
                highlightText: 'X92929292T', // Đoạn này sẽ tự động thành màu cam
                productImageUrl: 'https://img.freepik.com/free-photo/blue-t-shirt_125540-727.jpg', // Link ảnh test
                onTap: () {},
              ),
              const SizedBox(height: 16.0),

              // Type 2: Khuyến mãi (Có bôi cam thời gian)
              NotificationItem(
                type: NotificationType.promotion,
                title: 'Promotion has expired.',
                message: 'Your promotion will expire at 0:00 on October 28th.',
                highlightText: '0:00 on October 28th.', // Tuỳ biến highlight thoải mái
                onTap: () {},
              ),
              const SizedBox(height: 16.0),

              // Type 3: Hệ thống Update (Không có highlight text)
              NotificationItem(
                type: NotificationType.update,
                title: 'Notification Update',
                message: 'The system will be updated from 12 PM on November 1st to 3 PM on November 1st.',
                onTap: () {},
              ),
              const SizedBox(height: 16.0),

              // Lặp lại Type 1 để test danh sách dài
              NotificationItem(
                type: NotificationType.order,
                title: 'Package delivered successfully',
                message: 'Package Y88888888K has been successfully delivered to you.',
                highlightText: 'Y88888888K',
                productImageUrl: 'https://img.freepik.com/free-photo/blue-t-shirt_125540-727.jpg',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}