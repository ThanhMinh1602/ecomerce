import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerce/core/utils/app_utils.dart';
import 'package:ecomerce/data/models/category_model.dart';
import 'package:ecomerce/data/services/category_service.dart';
import 'package:ecomerce/data/services/cloudinary_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// Import các thành phần trong project của bạn
import 'package:ecomerce/core/base/base_controller.dart';
import 'package:uuid/uuid.dart';

class AdminCategoriesController extends BaseController {
  // 1. Các Service được truyền qua Constructor
  final CategoryService categoryService;
  final CloudinaryService cloudinaryService;

  AdminCategoriesController({
    required this.categoryService,
    required this.cloudinaryService,
  });

  // 2. Các Controller và Biến quan sát (Rx)
  final nameController = TextEditingController();

  // Dữ liệu hình ảnh được chọn
  var selectedImageBytes = Rxn<Uint8List>();
  var selectedImageName = "".obs;

  // Danh sách danh mục được đồng bộ Real-time từ Firestore
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // 3. Lắng nghe dữ liệu thay đổi từ Service ngay khi khởi tạo
    categories.bindStream(categoryService.streamCategories());
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  // ==========================================
  // CÁC HÀM XỬ LÝ LOGIC
  // ==========================================

  /// Làm sạch form sau khi sử dụng hoặc khi mở Dialog mới
  void clearFields() {
    nameController.clear();
    selectedImageBytes.value = null;
    selectedImageName.value = "";
  }

  /// Chọn hình ảnh từ thiết bị (Hỗ trợ tốt trên cả Web và Mobile)
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Tối ưu dung lượng trước khi upload
      );

      if (image != null) {
        selectedImageBytes.value = await image.readAsBytes();
        selectedImageName.value = image.name;
      }
    } catch (e) {
      showError("Không thể chọn ảnh: $e");
    }
  }

  Future<void> addCategory() async {
    if (nameController.text.trim().isEmpty ||
        selectedImageBytes.value == null) {
      showWarning("Vui lòng nhập tên và chọn ảnh!");
      return;
    }

    showLoading();

    try {
      // Tạo ID duy nhất bằng AppUtils [cite: 2026-02-26]
      var uuid = AppUtils.generateId();

      // Truyền folder dưới dạng sub-path (Service sẽ tự thêm tiền tố 'ecomerce/')
      String? publicId = await cloudinaryService.uploadImage(
        fileBytes: selectedImageBytes.value!,
        fileName: selectedImageName.value,
        folder: 'categories', // Bỏ dấu / ở đầu để Service xử lý cho sạch
      );

      if (publicId == null) {
        hideLoading();
        showError("Upload ảnh thất bại! Kiểm tra lại Preset.");
        return;
      }

      // Model lưu docId trùng với tên folder trên Cloudinary để dễ quản lý
      final newCategory = CategoryModel(
        id: uuid,
        name: nameController.text.trim(),
        imageUrl: publicId,
        createdAt: DateTime.now(),
      );

      await categoryService.addCategory(newCategory);

      hideLoading();
      Get.back();
      showSuccess("Thêm danh mục vào folder $uuid thành công!");
      clearFields();
    } catch (e) {
      hideLoading();
      showError("Lỗi: $e");
    }
  }

  /// Xóa danh mục (Có thể gọi từ UI khi nhấn nút xóa)
  void deleteCategory(CategoryModel category) {
    showDeleteConfirmDialog(
      itemName: category.name,
      onConfirm: () async {
        showLoading();
        try {
          await categoryService.deleteCategory(category);
          hideLoading();
          showSuccess("Đã xóa danh mục thành công!");
        } catch (e) {
          hideLoading();
          showError("Lỗi khi xóa: $e");
        }
      },
    );
  }
}
