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
}
