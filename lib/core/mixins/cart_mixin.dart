import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/data/models/cart_model.dart';
import 'package:ecomerce/data/services/cart_service.dart';
import 'package:get/get.dart';

mixin CartMixin on BaseController {
  final CartService _cartService = Get.find<CartService>();

  Future<void> handleAddToCart(CartItemModel item) async {
    showLoading();

    bool isSuccess = await _cartService.addToCart(item);

    hideLoading();

    if (isSuccess) {
      showSuccess('Đã thêm sản phẩm vào giỏ hàng!', title: 'Thành công');
    } else {
      showError('Không thể thêm vào giỏ hàng. Vui lòng thử lại!', title: 'Lỗi');
    }
  }
}
