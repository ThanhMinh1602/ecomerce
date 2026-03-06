import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/data/enums/order_status.dart';
import 'package:ecomerce/data/enums/payment_method_type.dart';
import 'package:ecomerce/data/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Nhớ import OrderStatus vào nhé
// import 'package:ecomerce/data/enums/order_status.dart';

class CheckoutController extends BaseController {
  late OrderModel order;

  // --- REACTIVE STATE (Biến phản ứng) ---
  final Rx<PaymentMethodType> selectedPaymentMethod = PaymentMethodType.cod.obs;
  final RxnString appliedDiscountCode = RxnString(null);
  final RxDouble discountAmount = 0.0.obs;
  final RxDouble shippingFee = 10.0.obs;

  @override
  void onInit() {
    super.onInit();
    // 1. Nhận order từ màn hình Cart
    if (Get.arguments is OrderModel) {
      order = Get.arguments as OrderModel;

      // Lúc này order.paymentMethod đã là Enum (theo OrderModel mới),
      // nên bạn gán thẳng như thế này là hoàn toàn chính xác!
      selectedPaymentMethod.value = order.paymentMethod;
    }
  }

  // --- LOGIC TÍNH TOÁN ---
  // Hàm tự động tính tổng tiền cuối cùng
  double get finalTotal => (order.totalAmount + shippingFee.value) - discountAmount.value;

  // --- ACTIONS ---
  void changePaymentMethod(PaymentMethodType method) {
    selectedPaymentMethod.value = method;
  }

  void applyDiscount() {
    // Giả lập gọi API áp mã thành công
    appliedDiscountCode.value = 'FREESHIP10';
    discountAmount.value = 10.0;
  }

  void placeOrder() {
    // ⚠️ Đã sửa: Gán trực tiếp đối tượng Enum vào chứ không gán String (.code)
    order.paymentMethod = selectedPaymentMethod.value;

    order.shippingAddress = '79k5 Phan Van Dinh, Da Nang';
    order.totalAmount = finalTotal;

    // ⚠️ Đã sửa: Dùng OrderStatus Enum thay cho chuỗi 'Pending'
    order.status = OrderStatus.pending;

    order.createdAt = DateTime.now();

    print("----- ĐƠN HÀNG SẴN SÀNG GỬI LÊN FIREBASE -----");
    // Hàm toJson trong OrderModel sẽ tự động lo việc chuyển Enum thành String để lưu lên Firebase
    print(order.toJson());

    // Thông báo thành công
    Get.snackbar(
      'Success',
      'Order placed successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }
}