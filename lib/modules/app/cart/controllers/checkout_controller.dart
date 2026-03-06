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

  // Tiêm PaymentService vào đây
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
    selectedPaymentMethod.value = method;
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
    // 1. Kiểm tra điều kiện tiên quyết: User phải có địa chỉ
    if (user.value == null || user.value!.addresses.isEmpty) {
      showError('Vui lòng thêm địa chỉ giao hàng trước khi thanh toán.');
      return;
    }

    // 2. Bật trạng thái Loading (Overlay xoay xoay)
    isLoading.value = true;

    try {
      // Tạo mã đơn hàng tạm thời để gửi cho PayPal/Lưu DB
      String orderId = "ORD-${DateTime.now().millisecondsSinceEpoch}";
      String selectedAddress = user.value!.addresses[selectedAddressIndex.value];

      // 3. Gọi Payment Service để thực hiện thanh toán
      // Hàm này giờ trả về Map? chứa thông tin từ PayPal
      final Map<String, dynamic>? paymentResult = await _paymentService.processPayment(
        selectedPaymentMethod.value,
        amount: finalTotal,
        currency: "USD",
        orderId: orderId,
        recipientName: user.value!.name,
        shippingAddress: selectedAddress,
      );

      // 4. Kiểm tra kết quả thanh toán
      if (paymentResult != null) {

        // --- CHUẨN BỊ DATA ĐỂ LƯU DATABASE ---

        // Gán các thông tin cơ bản
        order.id = orderId;
        order.userId = user.value!.id;
        order.customerName = user.value!.name;
        order.shippingAddress = selectedAddress;
        order.paymentMethod = selectedPaymentMethod.value;

        // Gán thông tin tài chính (lưu cả phí ship và giảm giá để đối soát)
        order.shippingFee = shippingFee.value;
        order.discountAmount = discountAmount.value;
        order.totalAmount = finalTotal;

        // Trạng thái đơn hàng và thời gian
        order.status = OrderStatus.pending;
        order.createdAt = DateTime.now();

        // Nếu là thanh toán PayPal, trích xuất thêm Payment ID và Email khách
        if (selectedPaymentMethod.value == PaymentMethodType.paypal) {
          final paypalData = paymentResult['data'];
          if (paypalData != null) {
            order.paymentId = paypalData['id']; // ID giao dịch PayPal (PAYID-...)
            order.payerEmail = paypalData['payer']?['payer_info']?['email'];
          }
        }

        // 5. Lưu đơn hàng lên Firestore thông qua OrderService
        final OrderService orderService = Get.find<OrderService>();
        bool saveSuccess = await orderService.createOrder(order);

        // 6. Kết thúc quá trình
        isLoading.value = false;

        if (saveSuccess) {
          // Xóa giỏ hàng local nếu cần (Service thường đã xử lý)
          // Điều hướng sang màn hình thành công
          // Get.offNamed(AppRouter.orderSuccess);
        } else {
          showError('Thanh toán thành công nhưng lỗi lưu đơn hàng. Vui lòng liên hệ hỗ trợ!');
        }

      } else {
        // Trường hợp paymentResult == null (User hủy hoặc lỗi cổng thanh toán)
        isLoading.value = false;
        // Thường không cần show lỗi ở đây vì PaymentService đã có log/snackbar rồi
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint("Lỗi PlaceOrder: $e");
      showError('Có lỗi xảy ra trong quá trình đặt hàng. Vui lòng thử lại.');
    }
  }
}