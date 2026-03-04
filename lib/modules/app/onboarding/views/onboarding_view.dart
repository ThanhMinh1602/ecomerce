import 'package:ecomerce/modules/app/onboarding/controllers/onboarding_controller.dart';
import 'package:ecomerce/modules/app/onboarding/widgets/onboarding_bottom_card.dart';
import 'package:ecomerce/modules/app/onboarding/widgets/onboarding_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


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
          PageView.builder(
            controller: pageController,
            itemCount: controller.onboardImages.length,
            onPageChanged: (index) => controller.pageIndex.value = index,
            itemBuilder: (context, index) {
              return Image.asset(
                controller.onboardImages[index].image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
          SafeArea(
            child: OnboardingTopBar(pageController: pageController),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: OnboardingBottomCard(pageController: pageController),
          ),
        ],
      ),
    );
  }
}