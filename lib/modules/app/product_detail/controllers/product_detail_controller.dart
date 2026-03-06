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
  // 1. Biến dữ liệu thành Rx để UI tự động render lại khi có sản phẩm mới
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

  // Tách hàm khởi tạo dữ liệu mặc định (màu, size, số lượng)
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

    quantity.value = 1; // Reset số lượng về 1
  }

  // 3. HÀM QUAN TRỌNG: Gọi hàm này khi bấm vào sản phẩm đề xuất
  void loadNewProduct(ProductModel newProduct, String newTag) {
    currentProduct.value = newProduct;
    currentHeroTag.value = newTag;

    _initProductData(newProduct);

    // Cuộn lên đầu trang một cách mượt mà
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
    final product = currentProduct.value; // Lấy dữ liệu hiện tại

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
      selectedColor: selectedColor.value.isNotEmpty ? selectedColor.value : null,
      selectedSize: selectedSize.value.isNotEmpty ? selectedSize.value : null,
      availableColors: product.colors,
      availableSizes: product.sizes
    );

     await handleAddToCart(cartItem);
    isAddingToCart.value = false;
  }

  void onTapBuyNow() {
    final product = currentProduct.value; // Lấy dữ liệu sản phẩm hiện tại cho ngắn gọn

    if (product.colors.isNotEmpty && selectedColor.value.isEmpty) {
      Get.snackbar('Chú ý', 'Vui lòng chọn màu sắc!');
      return;
    }
    if (product.sizes.isNotEmpty && selectedSize.value.isEmpty) {
      Get.snackbar('Chú ý', 'Vui lòng chọn kích thước!');
      return;
    }

    // 2. TẠO ITEM ĐẦY ĐỦ THÔNG TIN
    final buyNowItem = CartItemModel(
      id: '',
      productId: product.id,
      name: product.name,
      image: product.images.isNotEmpty ? product.images.first : '',
      price: product.price,
      quantity: quantity.value,
      selectedColor: selectedColor.value.isNotEmpty ? selectedColor.value : null,
      selectedSize: selectedSize.value.isNotEmpty ? selectedSize.value : null,
      isSelected: true,
    );

    // 3. TẠO ORDER
    OrderModel newOrder = OrderModel(
      id: '',
      userId: 'user_123', // TODO: Tương lai lấy từ AuthController (User đang đăng nhập)
      customerName: 'Sooti', // TODO: Tương lai lấy từ AuthController
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
    scrollController.dispose(); // Nhớ dispose để giải phóng bộ nhớ
    super.onClose();
  }
}