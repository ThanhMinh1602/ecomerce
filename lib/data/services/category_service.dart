import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerce/core/providers/firebase_provider.dart';
import 'package:ecomerce/data/services/cloudinary_service.dart';
import 'package:get/get.dart';
import '../models/category_model.dart';

class CategoryService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseProvider.firestore;
  final CloudinaryService _cloudinary = Get.find<CloudinaryService>();

  // 1. Lắng nghe danh sách Real-time
  Stream<List<CategoryModel>> streamCategories() {
    return _firestore
        .collection(FirebaseProvider.categories)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          List<CategoryModel> list = [];
          for (var doc in snapshot.docs) {
            try {
              final data = doc.data();
              list.add(CategoryModel.fromJson(data));
            } catch (e) {
              print("❌ Lỗi Mapping tại Document ID: ${doc.id} -> $e");
            }
          }
          return list;
        });
  }

  // 2. Thêm mới danh mục
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
      // Giả sử thuộc tính lưu link ảnh của bạn tên là 'imageUrl'.
      // Hãy đổi tên nếu model của bạn dùng tên khác (ví dụ: 'image', 'photoUrl'...)
      bool hasImage = category.imageUrl != null && category.imageUrl!.isNotEmpty;

      if (hasImage) {
        String folderPath = 'ecomerce/categories/${category.id}';
        print("Đang xóa folder: $folderPath");

        // BƯỚC 1: Xóa trên Cloudinary
        bool isCloudinaryOk = await _cloudinary.deleteFolder(folderPath);

        if (!isCloudinaryOk) {
          throw Exception(
            "Không thể xóa thư mục trên Cloudinary. Hủy thao tác xóa Firestore.",
          );
        }
        print("✅ Đã xóa dữ liệu trên Cloudinary.");
      } else {
        print("⏩ Danh mục không có hình ảnh, bỏ qua bước xóa Cloudinary.");
      }

      // BƯỚC 2: Xóa dữ liệu trên Firestore
      await _firestore
          .collection(FirebaseProvider.categories)
          .doc(category.id)
          .delete();

      print("✅ Đã xóa hoàn tất danh mục ID: ${category.id} trên Firestore.");
    } catch (e) {
      print("❌ Lỗi quy trình xóa danh mục: $e");
      rethrow;
    }
  }
}
