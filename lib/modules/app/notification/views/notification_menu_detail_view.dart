import 'package:ecomerce/core/components/app_bar/small_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationMenuDetailView extends StatelessWidget {
  const NotificationMenuDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: SmallAppBar(title: Get.arguments.toString()));
  }
}
