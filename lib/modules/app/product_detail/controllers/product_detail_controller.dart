import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/data/models/cart_model.dart';
import 'package:ecomerce/data/models/product_model.dart';
import 'package:ecomerce/data/services/cart_service.dart';
import 'package:get/get.dart';

class ProductDetailController extends BaseController {
  late ProductModel product;
  late String heroTag;

  final CartService _cartService = Get.find<CartService>();

  RxString selectedColor = ''.obs;
  RxString selectedSize = ''.obs;
  RxInt quantity = 1.obs;

  RxBool isAddingToCart = false.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is Map) {
      product = Get.arguments['product'] as ProductModel;
      heroTag = Get.arguments['heroTag'] as String;

      if (product.colors.isNotEmpty) {
        selectedColor.value = product.colors.first;
      }
      if (product.sizes.isNotEmpty) {
        selectedSize.value = product.sizes.first;
      }
    }
  }

  void selectColor(String color) => selectedColor.value = color;

  void selectSize(String size) => selectedSize.value = size;

  void increaseQuantity() {
    if (quantity.value < product.stock) {
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
    );

    bool isSuccess = await _cartService.addToCart(cartItem);

    isAddingToCart.value = false;

    if (isSuccess) {
      Get.snackbar(
        'Thành công',
        'Đã thêm ${product.name} vào giỏ hàng!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar('Lỗi', 'Không thể thêm vào giỏ hàng. Vui lòng thử lại!');
    }
  }
}
