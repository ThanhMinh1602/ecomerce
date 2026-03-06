import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerce/core/providers/firebase_provider.dart';
import 'package:ecomerce/core/utils/app_utils.dart';
import 'package:ecomerce/data/enums/order_status.dart';
import 'package:ecomerce/data/enums/payment_method_type.dart';
import 'package:ecomerce/data/models/order_model.dart';
import 'package:ecomerce/data/services/auth_service.dart';
import 'package:ecomerce/data/services/cart_service.dart';
import 'package:get/get.dart';

class OrderService extends GetxService {
  final FirebaseFirestore _db = FirebaseProvider.firestore;
  final AuthService _authService = Get.find<AuthService>();
  final CartService _cartService = Get.find<CartService>();

  
  Future<bool> placeOrder({
    required String shippingAddress,
    required PaymentMethodType paymentMethod,
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
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
      );

      await _db.collection('orders').doc(orderId).set(newOrder.toJson());

      
      await _cartService.clearCart();

      return true; 
    } catch (e) {
      print("Lỗi khi đặt hàng: $e");
      return false; 
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