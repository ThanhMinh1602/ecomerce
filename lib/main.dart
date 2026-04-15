import 'dart:io' show Platform;
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/data/binding/initial_binding.dart';
import 'package:ecomerce/firebase_options.dart';
import 'package:ecomerce/routes/app_page.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktopOrWeb = kIsWeb || (!kIsWeb && Platform.isWindows);

    final String initialAppRoute = isDesktopOrWeb
        ? AppRouter.adminLogin
        : AppRouter.splash;

    final Transition appTransition = kIsWeb
        ? Transition.noTransition
        : Transition.rightToLeft;

    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.orange500),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColor.white,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: initialAppRoute,
      initialBinding: InitialBinding(),
      getPages: AppPage.page,
      defaultTransition: appTransition,
      transitionDuration: Duration(milliseconds: 200),
    );
  }
}