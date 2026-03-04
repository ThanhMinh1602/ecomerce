import 'package:ecomerce/core/components/button/custom_button.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/modules/app/onboarding/controllers/onboarding_controller.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingBottomCard extends GetView<OnboardingController> {
  final PageController pageController;

  const OnboardingBottomCard({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0).copyWith(bottom: 40.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)), 
      ),
      child: Obx(() {
        final currentData = controller.onboardImages[controller.pageIndex.value];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentData.title,
              textAlign: TextAlign.center,
              style: AppStyle.titleBold.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 12.0),
            Text(
              currentData.subTitle,
              textAlign: TextAlign.center,
              style: AppStyle.smallContentRegular.copyWith(
                color: AppColor.k949494,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 48.0),
            SmoothPageIndicator(
              controller: pageController,
              count: controller.onboardImages.length,
              effect: const ExpandingDotsEffect(
                dotHeight: 12.0,
                dotWidth: 12.0,
                spacing:4.0,

                dotColor: AppColor.black100,
                activeDotColor: AppColor.orange500,
              ),
            ),
            const SizedBox(height: 32.0),
            CustomButton(
              btnText: 'Next',
              onPressed: () {
                if (controller.pageIndex.value == controller.onboardImages.length - 1) {
                  Get.offNamed(AppRouter.login);
                } else {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ],
        );
      }),
    );
  }
}