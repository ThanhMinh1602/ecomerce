import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:ecomerce/core/components/table/custom_admin_table.dart';
import 'package:ecomerce/data/models/category_model.dart';
import 'package:ecomerce/modules/admin/admin_categories/widgets/category_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/admin_categories_controller.dart';
import '../../admin_dashboard/widgets/admin_sidebar.dart';

class AdminCategoriesView extends GetView<AdminCategoriesController> {
  const AdminCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Row(
        children: [
          const AdminSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Obx(() {
                        if (controller.categories.isEmpty &&
                            controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.categories.isEmpty) {
                          return _buildEmptyState();
                        }
                        return _buildCategoryTable();
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Quản lý Danh mục',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              controller.clearFields();
              Get.dialog(const CategoryFormDialog(), barrierDismissible: false);
            },
            icon: const Icon(Icons.add, color: Colors.white, size: 18),
            label: const Text(
              'Thêm danh mục',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTable() {
    return CustomAdminTable<CategoryModel>(
      columns: const ['Hình ảnh', 'Tên danh mục', 'Ngày tạo', 'Thao tác'],
      items: controller.categories,
      isLoading: controller.isLoading.value,
      rowBuilder: (category, index) => DataRow(
        cells: [
          DataCell(_buildImageCell(category.imageUrl)),
          DataCell(
            Text(
              category.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          DataCell(Text(DateFormat('dd/MM/yyyy').format(category.createdAt))),
          DataCell(_buildActionButtons(category)),
        ],
      ),
    );
  }

  Widget _buildImageCell(String? publicId) {
    return Container(
      width: 45,
      height: 45,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: publicId != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CldImageWidget(publicId: publicId, fit: BoxFit.cover),
            )
          : const Icon(
              Icons.image_not_supported_outlined,
              color: Colors.grey,
              size: 20,
            ),
    );
  }

  Widget _buildActionButtons(CategoryModel category) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            controller.prepareEdit(category);
            Get.dialog(
              CategoryFormDialog(oldCategory: category),
              barrierDismissible: false,
            );
          },
          icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
          tooltip: 'Chỉnh sửa',
          hoverColor: Colors.blue.withOpacity(0.1),
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.all(8),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: () => controller.deleteCategory(category),
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.redAccent,
            size: 20,
          ),
          tooltip: 'Xóa danh mục',
          hoverColor: Colors.red.withOpacity(0.1),
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.all(8),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Chưa có danh mục nào được tạo.',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
