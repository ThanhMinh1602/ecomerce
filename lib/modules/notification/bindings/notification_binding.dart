import 'package:ecomerce/modules/cart/controllers/cart_controller.dart';
import 'package:ecomerce/modules/notification/controllers/notification_controller.dart';
import 'package:get/get.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationController());
  }
}
