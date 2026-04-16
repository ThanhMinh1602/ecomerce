import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/data/enums/order_status.dart';
import 'package:ecomerce/data/models/order_model.dart';
import 'package:ecomerce/data/services/order_service.dart';
import 'package:get/get.dart';

class AdminOrdersController extends BaseController {
  final OrderService _orderService = Get.find<OrderService>();

  // Lưu trữ toàn bộ đơn hàng từ stream
  final RxList<OrderModel> allOrders = <OrderModel>[].obs;

  // Lưu trữ danh sách đơn hàng đã được lọc để hiển thị lên UI
  final RxList<OrderModel> filteredOrders = <OrderModel>[].obs;

  // Lưu trữ từ khóa tìm kiếm hiện tại
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Lắng nghe sự thay đổi từ stream và cập nhật lại danh sách gốc
    _orderService.streamAllOrders().listen((data) {
      allOrders.value = data;
      // Mỗi khi có dữ liệu mới (ví dụ có đơn hàng mới), áp dụng lại bộ lọc tìm kiếm
      _applySearch();
    });
  }

  // Hàm được gọi khi user gõ vào thanh tìm kiếm
  void searchOrder(String query) {
    searchQuery.value = query;
    _applySearch();
  }

  // Hàm xử lý logic lọc đơn hàng
  void _applySearch() {
    if (searchQuery.value.trim().isEmpty) {
      filteredOrders.value = allOrders;
    } else {
      final query = searchQuery.value.trim().toLowerCase();
      filteredOrders.value = allOrders.where((order) {
        final orderId = order.id.toLowerCase();
        final customerName = order.customerName.toLowerCase();

        // Tìm theo Mã ĐH hoặc Tên khách hàng
        return orderId.contains(query) || customerName.contains(query);
      }).toList();
    }
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
