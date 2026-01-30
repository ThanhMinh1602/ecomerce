import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/routes/app_page.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.orange500),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColor.white,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouter.splash, // Khởi tạo route bình thường
      getPages: AppPage.page,
      defaultTransition: Transition.rightToLeft,
    );
  }
}
