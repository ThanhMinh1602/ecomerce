import 'dart:async';
import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/core/mixins/user_mixin.dart';
import 'package:ecomerce/data/enums/order_status.dart';
import 'package:ecomerce/data/models/order_model.dart';
import 'package:ecomerce/data/services/order_service.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:get/get.dart';

class ProfileController extends BaseController with UserMixin {
  final OrderService _orderService = Get.find<OrderService>();
  StreamSubscription<List<OrderModel>>? _orderSubscription;

  // Các biến đếm số lượng cho từng trạng thái (RxInt để UI tự động update)
  final RxInt pendingCount = 0.obs;    // Confirm
  final RxInt processingCount = 0.obs; // Packing
  final RxInt shippedCount = 0.obs;    // Deliver
  final RxInt deliveredCount = 0.obs;  // Assess

  @override
  void onInit() {
    super.onInit();
    // Bắt đầu lắng nghe dữ liệu đơn hàng ngay khi vào trang Profile
    _listenToMyOrders();
  }

  void _listenToMyOrders() {
    // Chỉ lấy đơn hàng nếu user đã đăng nhập
    if (isLoggedIn) {
      _orderSubscription = _orderService.streamMyOrders().listen((orders) {
        // Reset đếm về 0 mỗi khi có luồng data mới
        int pending = 0, processing = 0, shipped = 0, delivered = 0;

        // Phân loại và đếm
        for (var order in orders) {
          switch (order.status) {
            case OrderStatus.pending:
              pending++;
              break;
            case OrderStatus.processing:
              processing++;
              break;
            case OrderStatus.shipped:
              shipped++;
              break;
            case OrderStatus.delivered:
              delivered++;
              break;
            case OrderStatus.cancelled:
            // Thường đơn hủy sẽ không hiện thông báo đỏ trên thẻ Track Order
              break;
          }
        }

        // Cập nhật giá trị vào biến Rx
        pendingCount.value = pending;
        processingCount.value = processing;
        shippedCount.value = shipped;
        deliveredCount.value = delivered;
      });
    }
  }

  Future<void> onTapMyDetail() async {
    final result = await Get.toNamed(AppRouter.myDetails);
    if (result == true) {
      showSuccess('Update success');
    }
  }

  @override
  void onClose() {
    // Nhớ hủy lắng nghe khi thoát trang để tránh tràn bộ nhớ (Memory Leak)
    _orderSubscription?.cancel();
    super.onClose();
  }
}