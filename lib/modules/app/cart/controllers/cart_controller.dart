import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/data/enums/payment_method_type.dart';
import 'package:ecomerce/data/models/cart_model.dart';
import 'package:ecomerce/data/models/order_model.dart';
import 'package:ecomerce/data/services/cart_service.dart';
import 'package:ecomerce/data/services/auth_service.dart';
import 'package:ecomerce/data/services/product_service.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends BaseController {
  final CartService _cartService;

  final AuthService _authService;
  final ProductService _productService;

  CartController(this._cartService, this._authService, this._productService);

  RxList<CartItemModel> get cartItems => _cartService.cartItems;

  final RxSet<String> selectedItemIds = <String>{}.obs;

  double get selectedTotalPrice {
    return cartItems
        .where((item) => selectedItemIds.contains(item.id))
        .fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  bool get isCartEmpty => cartItems.isEmpty;

  void toggleItemSelection(String itemId, bool isSelected) {
    if (isSelected) {
      selectedItemIds.add(itemId);
    } else {
      selectedItemIds.remove(itemId);
    }
  }

  Future<void> increaseQuantity(CartItemModel item) async {
    showLoading();
    await _cartService.updateQuantity(item.id!, item.quantity + 1);
    hideLoading();
  }

  Future<void> decreaseQuantity(CartItemModel item) async {
    if (item.quantity > 1) {
      showLoading();
      await _cartService.updateQuantity(item.id!, item.quantity - 1);
      hideLoading();
    }
  }

  Future<void> removeItem(String itemId) async {
    showDeleteConfirmDialog(
      itemName: "this item",
      onConfirm: () async {
        showLoading();
        await _cartService.removeFromCart(itemId);
        selectedItemIds.remove(itemId);
        hideLoading();
      },
    );
  }

  void proceedToCheckout() {
    if (selectedTotalPrice <= 0) return;

    final selectedItems = cartItems
        .where((item) => selectedItemIds.contains(item.id))
        .toList();

    final currentUser = _authService.currentUser.value;

    OrderModel newOrder = OrderModel(
      id: '',
      userId: currentUser?.id ?? 'guest_id',
      customerName: currentUser?.name ?? 'Customer',
      items: selectedItems,
      totalAmount: selectedTotalPrice,
      shippingAddress: '',
      paymentMethod: PaymentMethodType.cod,
      createdAt: DateTime.now(),
    );

    Get.toNamed(AppRouter.checkout, arguments: newOrder);
  }

  Future<void> updateItemVariant(
    CartItemModel oldItem,
    String newSize,
    String newColor,
  ) async {
    if (oldItem.selectedSize == newSize && oldItem.selectedColor == newColor) {
      return;
    }

    showLoading();

    try {
      await _cartService.removeFromCart(oldItem.id);

      CartItemModel newItem = CartItemModel(
        id: '',
        productId: oldItem.productId,
        name: oldItem.name,
        image: oldItem.image,
        price: oldItem.price,
        quantity: oldItem.quantity,
        selectedSize: newSize,
        selectedColor: newColor,

        availableSizes: oldItem.availableSizes,
        availableColors: oldItem.availableColors,
      );

      await _cartService.addToCart(newItem);

      if (selectedItemIds.contains(oldItem.id)) {
        selectedItemIds.remove(oldItem.id);
      }

      showSuccess('Đã cập nhật phân loại sản phẩm!');
    } catch (e) {
      showError('Có lỗi xảy ra khi đổi phân loại.');
    } finally {
      hideLoading();
    }
  }
}
