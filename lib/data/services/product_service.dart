import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerce/core/providers/firebase_provider.dart';
import 'package:ecomerce/data/services/cloudinary_service.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';

class ProductService extends GetxService {
  final _db = FirebaseProvider.firestore;
  final CloudinaryService _cloudinary = Get.find<CloudinaryService>();

  Stream<List<ProductModel>> streamProducts() {
    return _db
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .distinct()
        .map(
          (q) => q.docs
              .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      await _db
          .collection(FirebaseProvider.products)
          .doc(product.id)
          .set(product.toJson());
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) async =>
      await _db.collection('products').doc(id).update(data);

  Future<void> deleteProduct(ProductModel product) async {
    try {
      String folderPath = 'ecomerce/products/${product.id}';

      print("Đang tiến hành xóa folder Product: $folderPath");

      if (product.images.isNotEmpty) {
        bool isCloudinaryOk = await _cloudinary.deleteFolder(folderPath);

        if (!isCloudinaryOk) {
          throw Exception(
            "Lỗi xóa ảnh Product trên Cloudinary. Hủy xóa dữ liệu Firestore.",
          );
        }
      }

      await _db.collection('products').doc(product.id).delete();

      print("✅ Đã xóa hoàn tất Product ID: ${product.id}");
    } catch (e) {
      print("❌ Lỗi trong quy trình xóa Product: $e");
      rethrow;
    }
  }

  Stream<List<ProductModel>> streamProductsByCategory(String categoryId) {
    return _db
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .distinct()
        .map(
          (q) => q.docs
              .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<ProductModel>> streamFilteredProducts(String type) {
    Query<Map<String, dynamic>> query = _db.collection('products');

    switch (type) {
      case 'Deals':
        query = query
            .where('oldPrice', isGreaterThan: 0)
            .orderBy('oldPrice', descending: true);
        break;

      case 'Trending':
        query = query
            .where('rating', isGreaterThanOrEqualTo: 4.5)
            .orderBy('rating', descending: true)
            .orderBy('reviewCount', descending: true);
        break;

      case 'Best seller':
        query = query.orderBy('reviewCount', descending: true);
        break;

      default:
        query = query.orderBy('createdAt', descending: true);
    }

    return query.snapshots().distinct().map(
      (q) => q.docs
          .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
          .toList(),
    );
  }
}
