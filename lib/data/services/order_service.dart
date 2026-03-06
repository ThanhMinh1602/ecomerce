import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerce/core/providers/firebase_provider.dart';
import 'package:ecomerce/core/utils/app_utils.dart';
import 'package:ecomerce/data/enums/order_status.dart';
import 'package:ecomerce/data/enums/payment_method_type.dart';
import 'package:ecomerce/data/models/order_model.dart';
import 'package:ecomerce/data/services/auth_service.dart';
import 'package:ecomerce/data/services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderService extends GetxService {
  final FirebaseFirestore _db = FirebaseProvider.firestore;
  final AuthService _authService = Get.find<AuthService>();
  final CartService _cartService = Get.find<CartService>();

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
  Future<bool> createOrder(OrderModel order) async {
    // 1. Khởi tạo một Batch (để thực hiện nhiều lệnh ghi cùng lúc)
    WriteBatch batch = _db.batch();

    try {
      // --- LỆNH 1: LƯU ĐƠN HÀNG ---
      DocumentReference orderRef = _db.collection('orders').doc(order.id);
      batch.set(orderRef, order.toJson());

      // Duyệt qua danh sách sản phẩm trong đơn hàng
      for (var item in order.items) {

        // --- LỆNH 2: TRỪ TỒN KHO TRONG DB ---
        // Giả sử collection sản phẩm của bạn là 'products'
        DocumentReference productRef = _db.collection('products').doc(item.productId);
        batch.update(productRef, {
          'stock': FieldValue.increment(-item.quantity), // Trừ đi số lượng khách đã mua
        });

        // --- LỆNH 3: XÓA SẢN PHẨM ĐÃ CHỌN KHỎI GIỎ HÀNG ---
        // Giả sử giỏ hàng lưu tại: users/{userId}/cart/{cartItemId}
        DocumentReference cartRef = _db.collection('users')
            .doc(order.userId)
            .collection('cart')
            .doc(item.id); // Dùng ID của item trong giỏ hàng để xóa
        batch.delete(cartRef);
      }

      // 2. Chốt Batch (Gửi toàn bộ lệnh lên Firebase cùng một lúc)
      await batch.commit();


      return true;
    } catch (e) {
      debugPrint("Lỗi khi xử lý Batch Order: $e");
      return false;
    }
  }
}