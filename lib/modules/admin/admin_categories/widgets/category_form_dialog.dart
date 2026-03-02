import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:ecomerce/core/components/dialog/custom_admin_dialog.dart';
import 'package:ecomerce/data/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_categories_controller.dart';

class CategoryFormDialog extends GetView<AdminCategoriesController> {
  final CategoryModel? oldCategory;

  const CategoryFormDialog({super.key, this.oldCategory});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomAdminDialog(
        width: 450,
        title: oldCategory == null ? "Thêm danh mục mới" : "Cập nhật danh mục",
        isLoading: controller.isLoading.value,
        saveText: oldCategory == null ? "Lưu danh mục" : "Cập nhật",
        onCancel: () => Get.back(),
        onSave: () => controller.saveCategory(oldCategory: oldCategory),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.nameController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Tên danh mục",
                hintText: "VD: Điện thoại, Laptop...",
                prefixIcon: const Icon(Icons.label_outline, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.blueAccent,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "Hình ảnh danh mục",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF4B566B),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: controller.pickImage,
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    style: BorderStyle.solid,
                  ),
                ),
                child: controller.selectedImageBytes.value != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Image.memory(
                          controller.selectedImageBytes.value!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : (oldCategory?.imageUrl != null)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: CldImageWidget(
                          publicId: oldCategory!.imageUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_photo_alternate_outlined,
                            color: Colors.blueAccent,
                            size: 40,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Nhấp để chọn hình ảnh",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
