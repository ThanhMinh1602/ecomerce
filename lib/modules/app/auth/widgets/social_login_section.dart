import 'package:ecomerce/core/constants/app_asset.dart';
import 'package:ecomerce/modules/app/auth/controllers/login_controller.dart';
import 'package:ecomerce/modules/app/auth/widgets/or_continue_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SocialLoginSection extends GetView<LoginController> {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        key: const ValueKey('social'),
        children: [
          const SizedBox(height: 30.0),
          const OrContinueWith(),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16.0,
            children: [
              // Nút Facebook
              GestureDetector(
                onTap: () => controller.loginWithFacebook(),
                child: SvgPicture.asset(AppAsset.facebook),
              ),

              // Nút Apple (Bạn chưa làm chức năng này nên tạm để trống)
              GestureDetector(
                onTap: () {
                  // controller.loginWithApple();
                  print('Chưa cấu hình đăng nhập Apple');
                },
                child: SvgPicture.asset(AppAsset.apple),
              ),

              // Nút Google
              GestureDetector(
                onTap: () => controller.loginWithGoogle(),
                child: SvgPicture.asset(AppAsset.google),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}