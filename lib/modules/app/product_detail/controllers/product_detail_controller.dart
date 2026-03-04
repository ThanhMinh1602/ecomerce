import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/data/models/cart_model.dart';
import 'package:ecomerce/data/models/product_model.dart';
import 'package:ecomerce/data/services/cart_service.dart';
import 'package:get/get.dart';

class ProductDetailController extends BaseController {
  // 1. Biến hứng dữ liệu từ trang trước
  late ProductModel product;
  late String heroTag;

  // 2. Gọi CartService để thêm hàng vào giỏ
  final CartService _cartService = Get.find<CartService>();

  // 3. Các biến Reactive (Rx) để cập nhật UI ngay lập tức
  RxString selectedColor = ''.obs;
  RxString selectedSize = ''.obs;
  RxInt quantity = 1.obs;

  // Biến dùng để hiện nút loading khi đang thêm vào giỏ
  RxBool isAddingToCart = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Hứng dữ liệu 'arguments' được truyền từ HomeController
    if (Get.arguments != null && Get.arguments is Map) {
      product = Get.arguments['product'] as ProductModel;
      heroTag = Get.arguments['heroTag'] as String; // Nhận Tag truyền qua
      // UX Tốt: Tự động chọn sẵn màu và size đầu tiên cho khách đỡ phải bấm nhiều
      if (product.colors.isNotEmpty) {
        selectedColor.value = product.colors.first;
      }
      if (product.sizes.isNotEmpty) {
        selectedSize.value = product.sizes.first;
      }
    }
  }

  // --- CÁC HÀM XỬ LÝ SỰ KIỆN TRÊN UI ---

  void selectColor(String color) => selectedColor.value = color;

  void selectSize(String size) => selectedSize.value = size;

  void increaseQuantity() {
    // Ngăn người dùng chọn quá số lượng hàng đang có trong kho
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

  // --- HÀM THÊM VÀO GIỎ HÀNG ---

  Future<void> addToCart() async {
    // 1. Kiểm tra xem sản phẩm có yêu cầu chọn màu/size không
    if (product.colors.isNotEmpty && selectedColor.value.isEmpty) {
      Get.snackbar('Chú ý', 'Vui lòng chọn màu sắc!');
      return;
    }
    if (product.sizes.isNotEmpty && selectedSize.value.isEmpty) {
      Get.snackbar('Chú ý', 'Vui lòng chọn kích thước!');
      return;
    }

    // 2. Bật trạng thái loading UI
    isAddingToCart.value = true;

    // 3. Chuyển ProductModel thành CartItemModel
    final cartItem = CartItemModel(
      id: '', // ID này CartService sẽ tự lo (ghép từ productId + size + color)
      productId: product.id,
      name: product.name,
      image: product.images.isNotEmpty ? product.images.first : '',
      price: product.price,
      quantity: quantity.value,
      selectedColor: selectedColor.value.isNotEmpty ? selectedColor.value : null,
      selectedSize: selectedSize.value.isNotEmpty ? selectedSize.value : null,
    );

    // 4. Gọi Service xử lý (trả về true/false)
    bool isSuccess = await _cartService.addToCart(cartItem);

    // 5. Tắt loading
    isAddingToCart.value = false;

    // 6. Thông báo cho người dùng
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