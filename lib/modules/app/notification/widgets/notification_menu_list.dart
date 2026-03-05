import 'package:ecomerce/data/enums/notification_type.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_asset.dart';
import 'notification_menu_button.dart';

class NotificationMenuList extends StatelessWidget {
  const NotificationMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(height: 16.0),
        itemCount: NotificationType.values.length,
        itemBuilder: (context, index) {
          return NotificationMenuButton(
            iconPath: NotificationType.values[index].iconPath,
            title: NotificationType.values[index].defaultTitle,
            onTap: () {
              Get.toNamed(AppRouter.notificationMenuDetail, arguments: NotificationType.values[index].defaultTitle);
            }
          );
        }

      ));

  }
}
