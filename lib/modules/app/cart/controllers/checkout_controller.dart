import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/data/enums/payment_method_type.dart';
import 'package:ecomerce/data/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      // Map từ string của order sang Enum
      selectedPaymentMethod.value = PaymentMethodType.fromString(order.paymentMethod);
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
    // Cập nhật data chuẩn bị bắn lên Firebase
    order.paymentMethod = selectedPaymentMethod.value.code;
    order.shippingAddress = '79k5 Phan Van Dinh, Da Nang';
    order.totalAmount = finalTotal;
    order.status = 'Pending';
    order.createdAt = DateTime.now();

    print("----- ĐƠN HÀNG SẴN SÀNG GỬI LÊN FIREBASE -----");
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