import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerce/core/providers/firebase_provider.dart';
import 'package:ecomerce/core/utils/app_utils.dart';
import 'package:ecomerce/data/models/order_model.dart';
import 'package:ecomerce/data/services/auth_service.dart';
import 'package:ecomerce/data/services/cart_service.dart';
import 'package:get/get.dart';

class OrderService extends GetxService {
  final FirebaseFirestore _db = FirebaseProvider.firestore;
  final AuthService _authService = Get.find<AuthService>();
  final CartService _cartService = Get.find<CartService>();

  // TRẢ VÊ TRUE / FALSE THAY VÌ SNACKBAR
  Future<bool> placeOrder({
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    final user = _authService.currentUser.value;
    final cartItems = _cartService.cartItems;

    if (user == null || cartItems.isEmpty) return false;

    try {
      String orderId = AppUtils.generateId();

      final newOrder = OrderModel(
        id: orderId,
        userId: user.id,
        customerName: user.name,
        items: cartItems.toList(),
        totalAmount: _cartService.totalPrice,
        shippingAddress: shippingAddress,
        paymentMethod: paymentMethod,
        status: 'Pending',
        createdAt: DateTime.now(),
      );

      await _db.collection('orders').doc(orderId).set(newOrder.toJson());

      // Xóa giỏ hàng nếu đặt đơn thành công
      await _cartService.clearCart();

      return true; // Thành công
    } catch (e) {
      print("Lỗi khi đặt hàng: $e");
      return false; // Thất bại
    }
  }

  Stream<List<OrderModel>> streamMyOrders() {
    final user = _authService.currentUser.value;
    if (user == null) return const Stream.empty();

    return _db
        .collection('orders')
        .where('userId', isEqualTo: user.id)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => OrderModel.fromJson(doc.data(), doc.id))
        .toList());
  }

  Stream<List<OrderModel>> streamAllOrders() {
    return _db
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => OrderModel.fromJson(doc.data(), doc.id))
        .toList());
  }

  // TRẢ VÊ TRUE / FALSE
  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _db.collection('orders').doc(orderId).update({'status': newStatus});
      return true;
    } catch (e) {
      print("Lỗi cập nhật đơn hàng: $e");
      return false;
    }
  }
}