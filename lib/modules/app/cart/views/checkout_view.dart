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
import 'package:ecomerce/core/extension/double_extension.dart';
import 'package:ecomerce/data/models/cart_model.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  Widget _buildOrderItem(CartItemModel item) {
    List<String> parts = [];
    if (item.selectedColor != null && item.selectedColor!.isNotEmpty)
      parts.add(item.selectedColor!);
    if (item.selectedSize != null && item.selectedSize!.isNotEmpty)
      parts.add('Size ${item.selectedSize}');
    String variantInfo = parts.join(', ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.network(
              item.image,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(width: 64, height: 64, color: Colors.grey[200]),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppStyle.smallContentBold.copyWith(
                    color: AppColor.black500,
                    fontSize: 15.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  variantInfo.isEmpty
                      ? 'Qty: ${item.quantity}'
                      : '$variantInfo, x${item.quantity}',
                  style: AppStyle.smallContentRegular.copyWith(
                    color: AppColor.k949494,
                    fontSize: 13.0,
                  ),
                ),
              ],
            ),
          ),
          Text(
            (item.price * item.quantity).formatPrice(),
            style: AppStyle.smallContentBold.copyWith(
              color: AppColor.black500,
              fontSize: 15.0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const SmallAppBar(title: 'Payment'),
      bottomNavigationBar: TransactionSummaryWidget(
        totalPrice: controller.order.totalAmount,
        shippingFee: controller.shippingFee.value,
        discount: controller.discountAmount.value,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddressSelectorWidget(
              name: 'Nguyen Nhat Trieu',
              phone: '+84 354 823 243',
              address: '79k5 Phan Van Dinh , Da Nang',
              onTap: () {},
            ),
            const SizedBox(height: 16.0),
            OrderItemsSectionWidget(items: controller.order.items,),
            const SizedBox(height: 16),
            Obx(
              () => PaymentMethodSectionWidget(
                selectedMethod: controller.selectedPaymentMethod.value,
                onChanged: controller.changePaymentMethod,
              ),
            ),
            const SizedBox(height: 16),
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
