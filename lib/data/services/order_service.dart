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
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<OrderModel>> streamAllOrders() {
    return _db
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
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
    WriteBatch batch = _db.batch();

    try {
      // 1. Lưu thông tin đơn hàng
      DocumentReference orderRef = _db.collection('orders').doc(order.id);
      batch.set(orderRef, order.toJson());

      // 2. Xử lý từng sản phẩm
      for (var item in order.items) {

        // --- CHỈ TRỪ KHO NẾU CÓ PRODUCT ID ---
        if (item.productId != null && item.productId.toString().trim().isNotEmpty) {
          DocumentReference productRef = _db.collection('products').doc(item.productId);
          batch.set(
              productRef,
              {'stock': FieldValue.increment(-item.quantity)},
              SetOptions(merge: true) // Dùng set merge để lỡ ID sai Firebase cũng tự tạo mới, không bị crash
          );
        } else {
          debugPrint("Bỏ qua trừ kho vì productId bị rỗng.");
        }

        // --- CHỈ XÓA GIỎ HÀNG NẾU CÓ ITEM ID VÀ USER ID ---
        if (item.id.toString().trim().isNotEmpty && order.userId.isNotEmpty) {
          DocumentReference cartRef = _db.collection('users')
              .doc(order.userId)
              .collection('cart')
              .doc(item.id);
          batch.delete(cartRef);
        } else {
          debugPrint("Bỏ qua xóa giỏ hàng vì item.id bị rỗng.");
        }
      }

      // 3. Thực thi lưu toàn bộ lên server
      await batch.commit();


      return true;
    } catch (e) {
      debugPrint("Lỗi khi xử lý Batch Order: $e");
      return false;
    }
  }
}
