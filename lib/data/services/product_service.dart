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

  Future<void> addProduct(ProductModel product) async =>
      await _db.collection('products').add(product.toJson());

  Future<void> updateProduct(String id, Map<String, dynamic> data) async =>
      await _db.collection('products').doc(id).update(data);

  Future<void> deleteProduct(ProductModel product) async {
    try {
      // 1. Xóa toàn bộ ảnh liên quan trên Cloudinary
      if (product.images.isNotEmpty) {
        await _cloudinary.deleteImages(product.images);
      }

      // 2. Sau đó mới xóa document trên Firestore
      await _db.collection('products').doc(product.id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
