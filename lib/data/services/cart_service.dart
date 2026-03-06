import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerce/core/providers/firebase_provider.dart';
import 'package:ecomerce/data/models/cart_model.dart';
import 'package:ecomerce/data/services/auth_service.dart';
import 'package:get/get.dart';

class CartService extends GetxService {
  final FirebaseFirestore _db = FirebaseProvider.firestore;
  final AuthService _authService = Get.find<AuthService>();

  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;

  double get totalPrice => cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  int get totalQuantity => cartItems.fold(0, (sum, item) => sum + item.quantity);

  @override
  void onInit() {
    super.onInit();
    ever(_authService.currentUser, (user) {
      if (user != null) {
        cartItems.bindStream(_streamCart(user.id));
      } else {
        cartItems.clear();
      }
    });

    if (_authService.currentUser.value != null) {
      cartItems.bindStream(_streamCart(_authService.currentUser.value!.id));
    }
  }

  Stream<List<CartItemModel>> _streamCart(String uid) {
    return _db
        .collection(FirebaseProvider.users)
        .doc(uid)
        .collection('cart')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CartItemModel.fromJson(doc.data(), doc.id))
        .toList());
  }

  Future<bool> addToCart(CartItemModel item) async {
    final user = _authService.currentUser.value;
    if (user == null) return false;

    try {
      final cartRef = _db.collection(FirebaseProvider.users).doc(user.id).collection('cart');
      String uniqueCartId = '${item.productId}_${item.selectedSize ?? "none"}_${item.selectedColor ?? "none"}';

      final docSnapshot = await cartRef.doc(uniqueCartId).get();

      if (docSnapshot.exists) {
        int currentQty = docSnapshot.data()?['quantity'] ?? 0;
        await cartRef.doc(uniqueCartId).update({'quantity': currentQty + item.quantity});
      } else {
        await cartRef.doc(uniqueCartId).set(item.toJson());
      }
      return true; // Thành công
    } catch (e) {
      print("Lỗi thêm vào giỏ: $e");
      return false; // Thất bại
    }
  }

  Future<bool> updateQuantity(String cartItemId, int newQuantity) async {
    final user = _authService.currentUser.value;
    if (user == null) return false;

    try {
      final docRef = _db.collection(FirebaseProvider.users).doc(user.id).collection('cart').doc(cartItemId);
      if (newQuantity <= 0) {
        await docRef.delete();
      } else {
        await docRef.update({'quantity': newQuantity});
      }
      return true;
    } catch (e) {
      print("Lỗi cập nhật số lượng: $e");
      return false;
    }
  }

  Future<bool> removeFromCart(String cartItemId) async {
    final user = _authService.currentUser.value;
    if (user == null) return false;

    try {
      await _db.collection(FirebaseProvider.users).doc(user.id).collection('cart').doc(cartItemId).delete();
      return true;
    } catch (e) {
      print("Lỗi xóa món hàng: $e");
      return false;
    }
  }

  Future<bool> clearCart() async {
    final user = _authService.currentUser.value;
    if (user == null) return false;

    try {
      final cartRef = _db.collection(FirebaseProvider.users).doc(user.id).collection('cart');
      final snapshots = await cartRef.get();

      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
      return true;
    } catch (e) {
      print("Lỗi dọn giỏ hàng: $e");
      return false;
    }
  }
}