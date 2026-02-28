import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomerce/core/utils/app_utils.dart';
import 'package:ecomerce/data/models/category_model.dart';
import 'package:ecomerce/data/services/category_service.dart';
import 'package:ecomerce/data/services/cloudinary_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ecomerce/core/base/base_controller.dart';
import 'package:uuid/uuid.dart';

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

  Future<void> addCategory() async {
    if (nameController.text.trim().isEmpty ||
        selectedImageBytes.value == null) {
      showWarning("Vui lòng nhập tên và chọn ảnh!");
      return;
    }

    showLoading();

    try {
      var uuid = AppUtils.generateId();

      String? publicId = await cloudinaryService.uploadImage(
        fileBytes: selectedImageBytes.value!,
        fileName: selectedImageName.value,
        folder: 'categories/$uuid',
      );

      if (publicId == null) {
        hideLoading();
        showError("Upload ảnh thất bại! Kiểm tra lại Preset.");
        return;
      }

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
