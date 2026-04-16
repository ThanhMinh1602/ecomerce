import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/data/enums/order_status.dart';
import 'package:ecomerce/data/enums/payment_method_type.dart';
import 'package:ecomerce/data/models/order_model.dart';
import 'package:ecomerce/data/models/user_model.dart';
import 'package:ecomerce/data/services/auth_service.dart';
import 'package:ecomerce/data/services/order_service.dart';
import 'package:ecomerce/data/services/payment_service.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutController extends BaseController {
  late OrderModel order;

  final PaymentService _paymentService = Get.find<PaymentService>();
  final OrderService orderService = Get.find<OrderService>();

  final Rx<PaymentMethodType> selectedPaymentMethod = PaymentMethodType.cod.obs;
  final RxnString appliedDiscountCode = RxnString(null);
  final RxDouble discountAmount = 0.0.obs;
  final RxDouble shippingFee = 10.0.obs;
  late final Rxn<UserModel> user;
  final RxInt selectedAddressIndex = 0.obs;
  final RxBool isAddressExpanded = false.obs;

  @override
  void onInit() {
    super.onInit();
    user = Get.find<AuthService>().currentUser;
    if (Get.arguments is OrderModel) {
      order = Get.arguments as OrderModel;
      selectedPaymentMethod.value = order.paymentMethod;
    }
  }

  double get finalTotal =>
      (order.totalAmount + shippingFee.value) - discountAmount.value;

  void changePaymentMethod(PaymentMethodType method) {
    if (method == PaymentMethodType.cod) {
      selectedPaymentMethod.value = method;
      return;
    }
    showError(
      'Hiện tại chỉ hỗ trợ thanh toán khi nhận hàng (COD). Vui lòng chọn COD để tiếp tục.',
    );
  }

  void applyDiscount() {
    appliedDiscountCode.value = 'FREESHIP10';
    discountAmount.value = 10.0;
  }

  void toggleAddressExpand() {
    isAddressExpanded.value = !isAddressExpanded.value;
  }

  void selectAddress(int index) {
    selectedAddressIndex.value = index;
    isAddressExpanded.value = false;
  }

  void onTapAddDelivery() {
    Get.toNamed(AppRouter.myDetails, arguments: true);
  }

  Future<void> placeOrder() async {
    if (user.value == null || user.value!.addresses.isEmpty) {
      showError('Vui lòng thêm địa chỉ giao hàng trước khi thanh toán.');
      return;
    }

    isLoading.value = true;

    try {
      String orderId = "ORD-${DateTime.now().millisecondsSinceEpoch}";
      String selectedAddress =
          user.value!.addresses[selectedAddressIndex.value];

      final Map<String, dynamic>? paymentResult = await _paymentService
          .processPayment(
            selectedPaymentMethod.value,
            amount: finalTotal,
            currency: "USD",
            orderId: orderId,
            recipientName: user.value!.name,
            shippingAddress: selectedAddress,
          );

      if (paymentResult != null) {
        order.id = orderId;
        order.userId = user.value!.id;
        order.customerName = user.value!.name;
        order.shippingAddress = selectedAddress;
        order.paymentMethod = selectedPaymentMethod.value;

        order.shippingFee = shippingFee.value;
        order.discountAmount = discountAmount.value;
        order.totalAmount = finalTotal;

        order.status = OrderStatus.pending;
        order.createdAt = DateTime.now();

        if (selectedPaymentMethod.value == PaymentMethodType.paypal) {
          final paypalData = paymentResult['data'];
          if (paypalData != null) {
            order.paymentId = paypalData['id'];
            order.payerEmail = paypalData['payer']?['payer_info']?['email'];
          }
        }

        if (selectedPaymentMethod.value == PaymentMethodType.cod) {
          order.payerEmail = "";
        }

        // Gọi OrderService để lưu đơn hàng
        bool saveSuccess = await orderService.createOrder(order);

        // Tắt loading
        isLoading.value = false;

        if (saveSuccess) {
          // --- CẬP NHẬT TẠI ĐÂY ---
          // 1. Đóng màn hình Checkout, quay về màn hình Cart
          Get.back();

          // 2. Hiển thị thông báo thành công (Tùy chỉnh text theo loại thanh toán)
          if (selectedPaymentMethod.value == PaymentMethodType.cod) {
            showSuccess(
              'Đặt hàng thành công! Vui lòng thanh toán khi nhận hàng.',
            );
          } else {
            showSuccess(
              'Thanh toán thành công! Đơn hàng của bạn đang được xử lý.',
            );
          }
        } else {
          showError(
            'Thanh toán thành công nhưng lỗi lưu đơn hàng. Vui lòng liên hệ hỗ trợ!',
          );
        }
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint("Lỗi PlaceOrder: $e");
      showError('Có lỗi xảy ra trong quá trình đặt hàng. Vui lòng thử lại.');
    }
  }
}
