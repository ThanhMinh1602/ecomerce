import 'package:ecomerce/core/components/button/custom_button.dart';
import 'package:ecomerce/core/extension/double_extension.dart';
import 'package:ecomerce/data/models/cart_model.dart';
import 'package:ecomerce/modules/app/cart/controllers/cart_controller.dart';
import 'package:ecomerce/modules/app/cart/widgets/cart_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:get/get.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Cart", style: AppStyle.contentBold),
        centerTitle: true,
        scrolledUnderElevation: 0.0,
      ),
      body: Obx(() {
        if (controller.isCartEmpty) {
          return Center(
            child: Text(
              "Your cart is empty",
              style: AppStyle.smallContentRegular.copyWith(
                color: AppColor.k949494,
              ),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                itemCount: controller.cartItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16.0),
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  final isSelected = controller.selectedItemIds.contains(
                    item.id,
                  );
                  return CartItemWidget(
                    isSelected: isSelected,
                    imageUrl: item.image ?? '',
                    title: item.name,
                    price: item.price,
                    quantity: item.quantity,
                    selectedSize: item.selectedSize ?? '',
                    selectedColor: item.selectedColor ?? '',
                    availableSizes: item.availableSizes,
                    availableColors: item.availableColors,
                    onVariantChanged: (String newSize, String newColor) {
                      controller.updateItemVariant(item, newSize, newColor);
                    },
                    onCheckboxChanged: (value) =>
                        controller.toggleItemSelection(item.id, value ?? false),
                    onIncrement: () => controller.increaseQuantity(item),
                    onDecrement: () => controller.decreaseQuantity(item),
                    onDelete: () => controller.removeItem(item.id),
                  );
                },
              ),
            ),
            _buildCheckoutBar(),
          ],
        );
      }),
    );
  }

  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 110.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Price',
                  style: AppStyle.smallContentRegular.copyWith(
                    color: AppColor.k949494,
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(height: 4.0),

                Obx(
                  () => Text(
                    controller.selectedTotalPrice.formatPrice(),
                    style: AppStyle.contentBold.copyWith(
                      color: AppColor.black500,
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            final hasSelectedItems = controller.selectedTotalPrice > 0;
            return Expanded(
              flex: 1,
              child: CustomButton(
                onPressed: hasSelectedItems
                    ? controller.proceedToCheckout
                    : null,
                btnText: 'Checkout',
              ),
            );
          }),
        ],
      ),
    );
  }
}
