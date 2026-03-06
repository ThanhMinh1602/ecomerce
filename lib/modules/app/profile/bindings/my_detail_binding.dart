import 'package:ecomerce/modules/app/profile/controllers/my_detail_view_controller.dart';
import 'package:get/get.dart';

class MyDetailBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> MyDetailViewController());
  }
}