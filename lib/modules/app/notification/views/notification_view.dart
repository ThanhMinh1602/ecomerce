import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/modules/app/notification/widgets/notification_list_view.dart';
import 'package:ecomerce/modules/app/notification/widgets/notification_menu_list.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Notification", style: AppStyle.contentBold),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
      ),
      body: ListView(
        children: [
          NotificationMenuList(),
          SizedBox(height: 20.0),
          NotificationListView(),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
