import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerce/core/providers/firebase_provider.dart';
import 'package:ecomerce/data/services/cloudinary_service.dart';
import 'package:get/get.dart';
import '../models/category_model.dart';

class CategoryService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseProvider.firestore;
  final CloudinaryService _cloudinary = Get.find<CloudinaryService>();

  // 1. Lấy danh sách danh mục theo thời gian thực (Stream)
  Stream<List<CategoryModel>> streamCategories() {
    return _firestore
        .collection(FirebaseProvider.categories)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => CategoryModel.fromJson(doc.data(), doc.id))
              .toList();
        });
  }

  // Trong file CategoryService.dart
  Future<void> addCategory(CategoryModel category) async {
    try {
      await _firestore
          .collection(FirebaseProvider.categories)
          .doc(category.id)
          .set(category.toJson());
    } catch (e) {
      rethrow;
    }
  }

  // 3. Cập nhật danh mục
  Future<void> updateCategory(String id, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(FirebaseProvider.categories)
          .doc(id)
          .update(data);
    } catch (e) {
      rethrow;
    }
  }

  // 4. Xóa danh mục
  Future<void> deleteCategory(CategoryModel category) async {
    try {
      // 1. Xóa ảnh của Category trên Cloudinary nếu có
      if (category.imageUrl != null) {
        await _cloudinary.deleteImages([category.imageUrl!]);
      }

      // 2. Xóa danh mục trên Firestore
      await _firestore
          .collection(FirebaseProvider.categories)
          .doc(category.id)
          .delete();
    } catch (e) {
      rethrow;
    }
  }
}
