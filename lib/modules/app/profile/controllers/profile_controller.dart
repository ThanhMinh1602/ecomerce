import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/core/mixins/user_mixin.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:get/get.dart';

class ProfileController extends BaseController with UserMixin {
  Future<void> onTapMyDetail() async {
    final result = await Get.toNamed(AppRouter.myDetails);
    if (result == true) {
      showSuccess('Update success');
    }
  }
}