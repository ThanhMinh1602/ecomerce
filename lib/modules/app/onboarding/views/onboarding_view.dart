import 'package:ecomerce/core/components/button/custom_button.dart';
import 'package:ecomerce/core/constants/app_asset.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/modules/app/onboarding/controllers/onboarding_controller.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final controller = Get.find<OnboardingController>();
  late PageController pageController;
  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: PageView.builder(
              controller: pageController,
              itemCount: controller.onboardImages.length,
              itemBuilder: (context, index) {
                final onboardImage = controller.onboardImages[index];
                return Image.asset(onboardImage.image, fit: BoxFit.cover);
              },
              onPageChanged: (index) {
                controller.pageIndex.value = index;
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
              ).copyWith(bottom: 24.0, top: 43.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
              ),
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      controller
                          .onboardImages[controller.pageIndex.value]
                          .title,
                      style: AppStyle.titleBold,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      textAlign: TextAlign.center,
                      controller
                          .onboardImages[controller.pageIndex.value]
                          .subTitle,
                      style: AppStyle.smallContentRegular,
                    ),
                    SizedBox(height: 90.0),
                    SmoothPageIndicator(
                      controller: pageController, // PageController
                      count: controller.onboardImages.length,
                      effect: ExpandingDotsEffect(
                        dotHeight: 12.0,
                        dotWidth: 12.0,
                        spacing: 4.0,
                        dotColor: AppColor.black100,
                        activeDotColor: AppColor.orange500,
                      ), // your preferred effect
                      onDotClicked: (index) {},
                    ),
                    SizedBox(height: 12.0),
                    CustomButton(
                      btnText: 'Next',
                      icon: AppAsset.arrowRight,
                      onPressed: () {
                        pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        if (controller.pageIndex.value ==
                            controller.onboardImages.length - 1) {
                          Get.offNamed(AppRouter.login);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
