import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/core/mixins/cart_mixin.dart';
import 'package:ecomerce/data/enums/payment_method_type.dart';
import 'package:ecomerce/data/models/cart_model.dart';
import 'package:ecomerce/data/models/order_model.dart';
import 'package:ecomerce/data/models/product_model.dart';
import 'package:ecomerce/data/services/cart_service.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailController extends BaseController with CartMixin {
  late Rx<ProductModel> currentProduct;
  late RxString currentHeroTag;

  final ScrollController scrollController = ScrollController();

  RxString selectedColor = ''.obs;
  RxString selectedSize = ''.obs;
  RxInt quantity = 1.obs;

  RxBool isAddingToCart = false.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is Map) {
      final p = Get.arguments['product'] as ProductModel;
      final t = Get.arguments['heroTag'] as String;

      currentProduct = p.obs;
      currentHeroTag = t.obs;

      _initProductData(p);
    }
  }

  void _initProductData(ProductModel p) {
    if (p.colors.isNotEmpty) {
      selectedColor.value = p.colors.first;
    } else {
      selectedColor.value = '';
    }

    if (p.sizes.isNotEmpty) {
      selectedSize.value = p.sizes.first;
    } else {
      selectedSize.value = '';
    }

    quantity.value = 1;
  }

  void loadNewProduct(ProductModel newProduct, String newTag) {
    currentProduct.value = newProduct;
    currentHeroTag.value = newTag;

    _initProductData(newProduct);

    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void selectColor(String color) => selectedColor.value = color;

  void selectSize(String size) => selectedSize.value = size;

  void increaseQuantity() {
    if (quantity.value < currentProduct.value.stock) {
      quantity.value++;
    } else {
      Get.snackbar('Thông báo', 'Số lượng vượt quá hàng trong kho!');
    }
  }

  void decreaseQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  Future<void> addToCart() async {
    final product = currentProduct.value;

    if (product.colors.isNotEmpty && selectedColor.value.isEmpty) {
      Get.snackbar('Chú ý', 'Vui lòng chọn màu sắc!');
      return;
    }
    if (product.sizes.isNotEmpty && selectedSize.value.isEmpty) {
      Get.snackbar('Chú ý', 'Vui lòng chọn kích thước!');
      return;
    }

    isAddingToCart.value = true;

    final cartItem = CartItemModel(
      id: '',
      productId: product.id,
      name: product.name,
      image: product.images.isNotEmpty ? product.images.first : '',
      price: product.price,
      quantity: quantity.value,
      selectedColor: selectedColor.value.isNotEmpty
          ? selectedColor.value
          : null,
      selectedSize: selectedSize.value.isNotEmpty ? selectedSize.value : null,
      availableColors: product.colors,
      availableSizes: product.sizes,
    );

    await handleAddToCart(cartItem);
    isAddingToCart.value = false;
  }

  void onTapBuyNow() {
    final product = currentProduct.value;

    if (product.colors.isNotEmpty && selectedColor.value.isEmpty) {
      Get.snackbar('Chú ý', 'Vui lòng chọn màu sắc!');
      return;
    }
    if (product.sizes.isNotEmpty && selectedSize.value.isEmpty) {
      Get.snackbar('Chú ý', 'Vui lòng chọn kích thước!');
      return;
    }

    final buyNowItem = CartItemModel(
      id: '',
      productId: product.id,
      name: product.name,
      image: product.images.isNotEmpty ? product.images.first : '',
      price: product.price,
      quantity: quantity.value,
      selectedColor: selectedColor.value.isNotEmpty
          ? selectedColor.value
          : null,
      selectedSize: selectedSize.value.isNotEmpty ? selectedSize.value : null,
      isSelected: true,
    );

    OrderModel newOrder = OrderModel(
      id: '',
      userId: 'user_123',
      customerName: 'Sooti',
      items: [buyNowItem],
      totalAmount: product.price * quantity.value,
      shippingAddress: '',
      paymentMethod: PaymentMethodType.cod,
      createdAt: DateTime.now(),
    );

    Get.toNamed(AppRouter.checkout, arguments: newOrder);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
