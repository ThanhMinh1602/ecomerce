import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:ecomerce/core/components/table/custom_admin_table.dart';
import 'package:ecomerce/data/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Import các thành phần trong project của bạn
import '../controllers/admin_categories_controller.dart';
import '../../admin_dashboard/widgets/admin_sidebar.dart';

class AdminCategoriesView extends GetView<AdminCategoriesController> {
  const AdminCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      // Sử dụng Obx để tự động cập nhật bảng khi danh sách thay đổi
                      child: Obx(() {
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

  /// Header chứa tiêu đề và nút thêm mới
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
              controller.clearFields(); // Reset form trước khi hiện dialog
              _showAddDialog();
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

  /// Bảng hiển thị danh mục (DataTable)
  Widget _buildCategoryTable() {
    return CustomAdminTable<CategoryModel>(
      columns: const ['Hình ảnh', 'Tên danh mục', 'Ngày tạo', 'Thao tác'],
      items: controller.categories,
      isLoading: controller
          .isLoading
          .value, // Bạn có thể nối với controller.isLoading nếu cần
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

  // Widget nhỏ hỗ trợ hiển thị ảnh
  // Widget hiển thị ảnh nhỏ gọn trong Table
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
              child: CldImageWidget(
                publicId: publicId,
                fit: BoxFit.cover,
                // Tối ưu: Cloudinary sẽ tự động nén ảnh xuống size nhỏ để load bảng cực nhanh
              ),
            )
          : const Icon(
              Icons.image_not_supported_outlined,
              color: Colors.grey,
              size: 20,
            ),
    );
  }

  // Widget chứa các nút thao tác Sửa/Xóa
  Widget _buildActionButtons(CategoryModel category) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Nút Sửa
        IconButton(
          onPressed: () {
            // controller.showEditDialog(category); // Hàm này mình sẽ làm ở bước tiếp theo
          },
          icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
          tooltip: 'Chỉnh sửa',
          hoverColor: Colors.blue.withOpacity(0.1),
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.all(8),
        ),
        const SizedBox(width: 4),
        // Nút Xóa
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

  /// Giao diện khi danh sách trống
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

  /// Dialog thêm danh mục mới
  void _showAddDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 450,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Thêm danh mục mới",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Trường nhập tên danh mục
              TextField(
                controller: controller.nameController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "Tên danh mục",
                  border: OutlineInputBorder(),
                  hintText: "VD: Điện thoại, Laptop...",
                  prefixIcon: Icon(Icons.label_outline),
                ),
              ),
              const SizedBox(height: 20),

              // Khu vực chọn ảnh
              const Text(
                "Hình ảnh danh mục",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Obx(
                () => GestureDetector(
                  onTap: controller.pickImage,
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: controller.selectedImageBytes.value != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              controller.selectedImageBytes.value!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                color: Colors.blueAccent,
                                size: 40,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Nhấp để chọn hình ảnh",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Các nút điều hướng trong Dialog
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      "Hủy bỏ",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(
                    () => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.addCategory,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Lưu danh mục",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
