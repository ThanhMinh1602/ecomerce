import 'dart:async';
import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/data/enums/order_status.dart';
import 'package:ecomerce/data/models/order_model.dart';
import 'package:ecomerce/data/services/order_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyOrdersController extends BaseController {
  final OrderService _orderService = Get.find<OrderService>();
  StreamSubscription<List<OrderModel>>? _orderSubscription;

  // 4 danh sách chứa đơn hàng theo từng trạng thái
  final RxList<OrderModel> pendingOrders = <OrderModel>[].obs;
  final RxList<OrderModel> processingOrders = <OrderModel>[].obs;
  final RxList<OrderModel> shippedOrders = <OrderModel>[].obs;
  final RxList<OrderModel> deliveredOrders = <OrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchMyOrders();
  }

  void _fetchMyOrders() {
    isLoading.value = true;

    // Lắng nghe real-time từ Firebase
    _orderSubscription = _orderService.streamMyOrders().listen(
          (orders) {
        // Lọc đơn hàng và gán vào từng danh sách tương ứng
        pendingOrders.value = orders.where((o) => o.status == OrderStatus.pending).toList();
        processingOrders.value = orders.where((o) => o.status == OrderStatus.processing).toList();
        shippedOrders.value = orders.where((o) => o.status == OrderStatus.shipped).toList();
        deliveredOrders.value = orders.where((o) => o.status == OrderStatus.delivered).toList();

        isLoading.value = false;
      },
      onError: (error) {
        isLoading.value = false;
        showError('Có lỗi xảy ra khi tải lịch sử đơn hàng.');
      },
    );
  }

  // Tiện ích format ngày tháng (VD: Mar 06, 2026)
  String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  void onClose() {
    _orderSubscription?.cancel(); // Tránh tràn bộ nhớ
    super.onClose();
  }
}