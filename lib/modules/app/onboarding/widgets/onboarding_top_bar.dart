import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/modules/app/onboarding/controllers/onboarding_controller.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingTopBar extends GetView<OnboardingController> {
  final PageController pageController;

  const OnboardingTopBar({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            controller.pageIndex.value > 0
                ? IconButton(
                    icon:  Icon(Icons.arrow_back, color: AppColor.black500),
                    onPressed: () {
                      pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  )
                : const SizedBox(width: 48),
            TextButton(
              onPressed: () {
                controller.completeOnboarding();
                Get.offNamed(AppRouter.login);
              },
              child: Text(
                'Skip',
                style: AppStyle.smallContentBold.copyWith(
                  color: Colors.black87,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
