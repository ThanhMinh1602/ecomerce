import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerce/core/providers/firebase_provider.dart';
import 'package:ecomerce/data/services/cloudinary_service.dart';
import 'package:get/get.dart';
import '../models/category_model.dart';

class CategoryService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseProvider.firestore;
  final CloudinaryService _cloudinary = Get.find<CloudinaryService>();
  Stream<List<CategoryModel>> streamCategories() {
    return _firestore
        .collection(FirebaseProvider.categories)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          // Trình dọn dẹp: Bỏ qua những document lỗi để app tiếp tục chạy
          List<CategoryModel> list = [];
          for (var doc in snapshot.docs) {
            try {
              final data = doc.data();
              list.add(CategoryModel.fromJson(data));
            } catch (e) {
              print("❌ Lỗi Mapping tại Document ID: ${doc.id} -> $e");
              // Bỏ qua document này, không để nó làm crash cả list
            }
          }
          return list;
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

  // 4. Xóa danh mục: Chỉ thành công nếu cả 2 bên đều xóa xong [cite: 2026-02-28]
  Future<void> deleteCategory(CategoryModel category) async {
    try {
      String folderPath = 'ecomerce/categories/${category.id}';
      print("Đang xóa folder: $folderPath");

      // BƯỚC 1: Xóa trên Cloudinary trước
      bool isCloudinaryOk = await _cloudinary.deleteFolder(folderPath);

      // Nếu Cloudinary thất bại, ném lỗi để dừng quy trình [cite: 2026-02-28]
      if (!isCloudinaryOk) {
        throw Exception(
          "Không thể xóa thư mục trên Cloudinary. Hủy thao tác xóa Firestore.",
        );
      }

      // BƯỚC 2: Chỉ khi Cloudinary xong mới xóa Firestore [cite: 2026-02-28]
      await _firestore
          .collection(FirebaseProvider.categories)
          .doc(category.id)
          .delete();

      print("✅ Đã xóa sạch cả 2 hệ thống cho ID: ${category.id}");
    } catch (e) {
      print("❌ Lỗi quy trình xóa danh mục: $e");
      rethrow; // Ném lỗi để Controller hiển thị thông báo cho Minh
    }
  }
}
