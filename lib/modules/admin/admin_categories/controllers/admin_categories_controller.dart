import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ecomerce/core/utils/app_utils.dart';
import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/data/models/category_model.dart';
import 'package:ecomerce/data/services/category_service.dart';
import 'package:ecomerce/data/services/cloudinary_service.dart';

class AdminCategoriesController extends BaseController {
  final CategoryService categoryService;
  final CloudinaryService cloudinaryService;

  AdminCategoriesController({
    required this.categoryService,
    required this.cloudinaryService,
  });

  final nameController = TextEditingController();

  var selectedImageBytes = Rxn<Uint8List>();
  var selectedImageName = "".obs;

  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    categories.bindStream(categoryService.streamCategories());
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  void clearFields() {
    nameController.clear();
    selectedImageBytes.value = null;
    selectedImageName.value = "";
  }

  void prepareEdit(CategoryModel category) {
    clearFields();
    nameController.text = category.name;
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImageBytes.value = await image.readAsBytes();
        selectedImageName.value = image.name;
      }
    } catch (e) {
      showError("Không thể chọn ảnh: $e");
    }
  }

  // Dùng chung cho cả Thêm mới và Cập nhật
  Future<void> saveCategory({CategoryModel? oldCategory}) async {
    if (nameController.text.trim().isEmpty) {
      return showWarning("Vui lòng nhập tên danh mục!");
    }

    if (oldCategory == null && selectedImageBytes.value == null) {
      return showWarning("Vui lòng chọn hình ảnh cho danh mục!");
    }

    showLoading();

    try {
      var uuid = oldCategory?.id ?? AppUtils.generateId();
      String? finalImageUrl = oldCategory?.imageUrl;

      if (selectedImageBytes.value != null) {
        String? publicId = await cloudinaryService.uploadImage(
          fileBytes: selectedImageBytes.value!,
          fileName: selectedImageName.value,
          folder: 'categories/$uuid',
        );

        if (publicId == null) {
          hideLoading();
          return showError("Upload ảnh thất bại! Kiểm tra lại cấu hình.");
        }
        finalImageUrl = publicId;
      }

      final categoryData = CategoryModel(
        id: uuid,
        name: nameController.text.trim(),
        imageUrl: finalImageUrl,
        createdAt: oldCategory?.createdAt ?? DateTime.now(),
      );

      if (oldCategory == null) {
        await categoryService.addCategory(categoryData);
        showSuccess("Thêm danh mục thành công!");
      } else {
        await categoryService.updateCategory(uuid, categoryData.toJson());
        showSuccess("Cập nhật danh mục thành công!");
      }

      hideLoading();
      Get.back();
      clearFields();
    } catch (e) {
      hideLoading();
      showError("Lỗi hệ thống: $e");
    }
  }

  void deleteCategory(CategoryModel category) {
    showDeleteConfirmDialog(
      itemName: category.name,
      onConfirm: () async {
        showLoading();
        try {
          await categoryService.deleteCategory(category);
          hideLoading();
          showSuccess("Đã xóa hoàn toàn danh mục!");
        } catch (e) {
          hideLoading();
          showError("Lỗi khi xóa: $e");
        }
      },
    );
  }
}
