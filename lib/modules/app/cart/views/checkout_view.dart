import 'package:ecomerce/core/components/empty_address_widget.dart';
import 'package:ecomerce/modules/app/cart/controllers/checkout_controller.dart';
import 'package:ecomerce/modules/app/cart/widgets/address_selector_widget.dart';
import 'package:ecomerce/modules/app/cart/widgets/discount_selector_widget.dart';
import 'package:ecomerce/modules/app/cart/widgets/order_items_section_widget.dart';
import 'package:ecomerce/modules/app/cart/widgets/payment_method_section_widget.dart';
import 'package:ecomerce/modules/app/cart/widgets/transaction_summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_style.dart';
import 'package:ecomerce/core/components/app_bar/small_app_bar.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const SmallAppBar(title: 'Payment'),

      bottomNavigationBar: Obx(() {
        final user = controller.user.value;
        final hasAddress = user != null && user.addresses.isNotEmpty;
        return TransactionSummaryWidget(
          totalPrice: controller.order.totalAmount,
          shippingFee: controller.shippingFee.value,
          discount: controller.discountAmount.value,
          onPressed: hasAddress ? () {} : null,
        );
      }),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Obx(() {
              final user = controller.user.value;
              final hasAddress = user != null && user.addresses.isNotEmpty;

              if (hasAddress) {
                return AddressSelectorWidget(
                  name: user.name,
                  phone: user.phone,
                  addresses: user.addresses,

                  selectedIndex: controller.selectedAddressIndex.value,
                  isExpanded: controller.isAddressExpanded.value,
                  onTap: controller.toggleAddressExpand,

                  onSelect: (index) => controller.selectAddress(index),
                );
              } else {
                return EmptyAddressWidget(onTap: controller.onTapAddDelivery);
              }
            }),
            const SizedBox(height: 24.0),

            OrderItemsSectionWidget(items: controller.order.items),
            const SizedBox(height: 16),

            Text('Payment Method', style: AppStyle.smallContentBold),
            const SizedBox(height: 12),
            Obx(
              () => PaymentMethodSectionWidget(
                selectedMethod: controller.selectedPaymentMethod.value,
                onChanged: controller.changePaymentMethod,
              ),
            ),
            const SizedBox(height: 24),

            Obx(
              () => DiscountSelectorWidget(
                selectedDiscountCode: controller.appliedDiscountCode.value,
                onTap: controller.applyDiscount,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
