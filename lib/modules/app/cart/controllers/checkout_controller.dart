import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/data/enums/order_status.dart';
import 'package:ecomerce/data/enums/payment_method_type.dart';
import 'package:ecomerce/data/models/order_model.dart';
import 'package:ecomerce/data/models/user_model.dart';
import 'package:ecomerce/data/services/auth_service.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutController extends BaseController {
  late OrderModel order;

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

  void placeOrder() {
    order.paymentMethod = selectedPaymentMethod.value;

    order.shippingAddress = '79k5 Phan Van Dinh, Da Nang';
    order.totalAmount = finalTotal;

    order.status = OrderStatus.pending;

    order.createdAt = DateTime.now();

    print("----- ĐƠN HÀNG SẴN SÀNG GỬI LÊN FIREBASE -----");

    print(order.toJson());

    Get.snackbar(
      'Success',
      'Order placed successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }
}
