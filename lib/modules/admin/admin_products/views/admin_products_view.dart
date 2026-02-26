import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:ecomerce/core/components/table/custom_admin_table.dart';
import 'package:ecomerce/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/admin_products_controller.dart';
import '../../admin_dashboard/widgets/admin_sidebar.dart';

class AdminProductsView extends GetView<AdminProductsController> {
  const AdminProductsView({super.key});

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
                // Trong file AdminProductsView.dart
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      decoration: _cardDecoration(),
                      // QUAN TRỌNG: Phải có Obx ở đây để lắng nghe controller.products thay đổi
                      child: Obx(() {
                        // Kiểm tra nếu đang loading lần đầu hoặc list trống
                        if (controller.products.isEmpty &&
                            controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return CustomAdminTable<ProductModel>(
                          columns: const [
                            'Ảnh',
                            'Tên sản phẩm',
                            'Danh mục',
                            'Giá',
                            'Kho',
                            'Thao tác',
                          ],
                          items: controller
                              .products, // RxList sẽ kích hoạt Obx re-build [cite: 2026-02-26]
                          rowBuilder: (product, index) => DataRow(
                            cells: [
                              DataCell(
                                _buildImageCell(product.images.firstOrNull),
                              ),
                              DataCell(
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataCell(_buildCategoryName(product.categoryId)),
                              DataCell(
                                Text(
                                  NumberFormat.currency(
                                    locale: 'vi_VN',
                                    symbol: '₫',
                                  ).format(product.price),
                                ),
                              ),
                              DataCell(Text(product.stock.toString())),
                              DataCell(_buildActionButtons(product)),
                            ],
                          ),
                        );
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

  // --- WIDGETS CHI TIẾT ---

  Widget _buildHeader() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Quản lý Sản phẩm',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ElevatedButton.icon(
            onPressed: () {
              controller.clearFields();
              _showProductDialog();
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Thêm sản phẩm mới',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryName(String categoryId) {
    final cat = controller.categories.firstWhereOrNull(
      (c) => c.id == categoryId,
    );
    return Text(cat?.name ?? 'N/A', style: TextStyle(color: Colors.grey[600]));
  }

  Widget _buildImageCell(String? publicId) {
    return Container(
      width: 45,
      height: 45,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[100],
      ),
      child: publicId != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CldImageWidget(publicId: publicId, fit: BoxFit.cover),
            )
          : const Icon(Icons.image, color: Colors.grey, size: 20),
    );
  }

  Widget _buildActionButtons(ProductModel product) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
          onPressed: () {
            controller.prepareEdit(product);
            _showProductDialog(oldProduct: product);
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.redAccent,
            size: 20,
          ),
          onPressed: () => controller.deleteProduct(product),
        ),
      ],
    );
  }

  // --- DIALOG FORM ---

  void _showProductDialog({ProductModel? oldProduct}) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 800, // Tăng chiều rộng để chứa nhiều field hơn

          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  oldProduct == null ? "Thêm sản phẩm" : "Cập nhật sản phẩm",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                _buildTextField(
                  controller.nameController,
                  "Tên sản phẩm (Ví dụ: Regular Fit shirt)",
                ), //
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(child: _buildCategoryDropdown()),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller.stockController,
                        "Số lượng kho",
                        isNumber: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller.priceController,
                        "Giá hiện tại",
                        isNumber: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller.oldPriceController,
                        "Giá cũ (Gạch ngang)",
                        isNumber: true,
                      ),
                    ), //
                  ],
                ),
                const SizedBox(height: 16),
                // QUẢN LÝ SIZE
                const Text(
                  "Kích thước (Sizes)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildSizeManager(),
                const SizedBox(height: 20),

                _buildTextField(
                  controller.descController,
                  "Mô tả sản phẩm",
                  maxLines: 4,
                ), //
                const SizedBox(height: 24),

                const Text(
                  "Hình ảnh sản phẩm",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildImagePickerArea(),

                const SizedBox(height: 32),
                _buildDialogActions(oldProduct),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Widget quản lý size bằng Chip
  Widget _buildSizeManager() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.sizeInputController,
                decoration: const InputDecoration(
                  hintText: "Nhập size (VD: S, M, XL...)",
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (val) => controller.addSize(val),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () =>
                  controller.addSize(controller.sizeInputController.text),
              child: const Text("Thêm"),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Obx(
          () => Wrap(
            spacing: 8,
            children: controller.sizes
                .map(
                  (size) => Chip(
                    label: Text(size),
                    onDeleted: () => controller.removeSize(size),
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    deleteIconColor: Colors.red,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  // --- FORM COMPONENTS ---

  Widget _buildTextField(
    TextEditingController ctrl,
    String label, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: controller.selectedCategoryId.value,
        decoration: const InputDecoration(
          labelText: "Danh mục",
          border: OutlineInputBorder(),
        ),
        items: controller.categories
            .map(
              (cat) => DropdownMenuItem(value: cat.id, child: Text(cat.name)),
            )
            .toList(),
        onChanged: (val) => controller.selectedCategoryId.value = val,
      ),
    );
  }

  Widget _buildImagePickerArea() {
    return Obx(
      () => Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          // 1. HIỂN THỊ ẢNH ĐANG CÓ TRÊN CLOUD (ẢNH CŨ)
          ...List.generate(
            controller.existingImages.length,
            (index) => _buildImageThumbnail(
              child: CldImageWidget(
                publicId: controller.existingImages[index],
                fit: BoxFit.cover,
              ),
              onRemove: () => controller.removeExistingImage(index),
              isOld: true,
            ),
          ),

          // 2. HIỂN THỊ ẢNH MỚI CHỌN (FILE BYTES)
          ...List.generate(
            controller.selectedImagesBytes.length,
            (index) => _buildImageThumbnail(
              child: Image.memory(
                controller.selectedImagesBytes[index],
                fit: BoxFit.cover,
              ),
              onRemove: () => controller.removeSelectedImage(index),
            ),
          ),

          // 3. NÚT CHỌN THÊM ẢNH
          _buildAddImageButton(),
        ],
      ),
    );
  }

  // Widget Thumbnail dùng chung
  Widget _buildImageThumbnail({
    required Widget child,
    required VoidCallback onRemove,
    bool isOld = false,
  }) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isOld ? Colors.blueAccent : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: child,
          ),
        ),
        Positioned(
          right: 4,
          top: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
        if (isOld)
          Positioned(
            left: 4,
            bottom: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              color: Colors.blueAccent.withOpacity(0.8),
              child: const Text(
                "Cloud",
                style: TextStyle(color: Colors.white, fontSize: 8),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: controller.pickMultipleImages,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
            style: BorderStyle.none,
          ),
        ),
        child: const Icon(
          Icons.add_a_photo_outlined,
          color: Colors.blueAccent,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildDialogActions(ProductModel? oldProduct) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(onPressed: () => Get.back(), child: const Text("Hủy")),
        const SizedBox(width: 12),
        Obx(
          () => ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () => controller.saveProduct(oldProduct: oldProduct),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: controller.isLoading.value
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Hiển thị % tiến độ ngay tại đây
                      Text(
                        "Đang tải... ${(controller.uploadProgress.value * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                : const Text(
                    "Lưu sản phẩm",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
    );
  }
}
