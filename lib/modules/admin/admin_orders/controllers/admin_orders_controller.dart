import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/data/enums/order_status.dart';
import 'package:ecomerce/data/models/order_model.dart';
import 'package:ecomerce/data/services/order_service.dart';
import 'package:get/get.dart';

class AdminOrdersController extends BaseController {
  final OrderService _orderService = Get.find<OrderService>();

  final RxList<OrderModel> orders = <OrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    orders.bindStream(_orderService.streamAllOrders());
  }

  Future<void> changeOrderStatus(String orderId, OrderStatus newStatus) async {
    isLoading.value = true;

    bool success = await _orderService.updateOrderStatus(
      orderId,
      newStatus.code,
    );

    isLoading.value = false;

    if (success) {
      showSuccess('Cập nhật trạng thái đơn hàng thành công!');
    } else {
      showError('Có lỗi xảy ra, không thể cập nhật.');
    }
  }

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}
