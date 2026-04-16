import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/core/constants/app_asset.dart';
import 'package:ecomerce/data/models/onboarding_model.dart';
import 'package:ecomerce/data/services/preferences_service.dart';
import 'package:get/get.dart';

class OnboardingController extends BaseController {
  late final List<OnboardingModel> onboardImages;
  RxInt pageIndex = 0.obs;
  final PreferencesService _preferencesService = PreferencesService();

  @override
  void onInit() {
    onboardImages = [
      OnboardingModel(
        image: AppAsset.onboarding1,
        title: 'Discover Your Style',
        subTitle:
            'Browse thousands of exclusive items from top brands, curated specially for your taste',
      ),
      OnboardingModel(
        image: AppAsset.onboarding2,
        title: 'Discover Your Style',
        subTitle:
            'Browse thousands of exclusive items from top brands, curated specially for your taste',
      ),
      OnboardingModel(
        image: AppAsset.onboarding3,
        title: 'Discover Your Style',
        subTitle:
            'Browse thousands of exclusive items from top brands, curated specially for your taste',
      ),
    ];
    super.onInit();
  }

  Future<void> completeOnboarding() async {
    await _preferencesService.setOnboardingShown();
  }
}
