import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  
  HomeAppBar({super.key});

  
  final AuthService _authService = Get.find<AuthService>();

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 18) {
      return 'Good afternoon';
    } else if (hour >= 18 && hour < 22) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 65.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 28,
              
              backgroundImage: NetworkImage(
                'https://blog.vn.revu.net/wp-content/uploads/2025/09/anh-son-tung-mtp-thumb.jpg',

              ),
            ),
            const SizedBox(width: 12.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  final fullName = _authService.currentUser.value?.name.trim() ?? 'Sooti';
                  final lastName = fullName.isNotEmpty
                      ? fullName.split(RegExp(r'\s+')).last
                      : 'Sooti';

                  return Text(
                      '${_getGreeting()}, $lastName!',
                      style: AppStyle.smallContentBold
                  );
                }),
                Text(
                  'Welcome to FashionShop',
                  style: AppStyle.smallContentRegular,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 65.0);
}