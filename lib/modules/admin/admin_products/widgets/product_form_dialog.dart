import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:ecomerce/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_products_controller.dart';

class ProductFormDialog extends GetView<AdminProductsController> {
  final ProductModel? oldProduct;

  const ProductFormDialog({super.key, this.oldProduct});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor:
          Colors.transparent, // Cực kỳ quan trọng để nền trắng tinh
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 850, // Form rộng rãi
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 16,
                top: 16,
                bottom: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    oldProduct == null
                        ? "Thêm sản phẩm mới"
                        : "Cập nhật sản phẩm",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B3445),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Get.back(),
                    splashRadius: 24,
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),

            // --- BODY (SCROLLABLE) ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section: Thông tin cơ bản
                    _buildSectionTitle("1. Thông tin cơ bản"),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller.nameController,
                      "Tên sản phẩm (Ví dụ: Áo thun Regular Fit)",
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildCategoryDropdown()),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller.stockController,
                            "Số lượng trong kho",
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Section: Định giá & Phân loại
                    _buildSectionTitle("2. Định giá & Phân loại"),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller.priceController,
                            "Giá bán hiện tại (VNĐ)",
                            isNumber: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller.oldPriceController,
                            "Giá gốc (VNĐ) - Gạch ngang",
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Kích thước (Sizes)",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B566B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSizeManager(),
                    const SizedBox(height: 32),

                    // Section: Chi tiết & Hình ảnh
                    _buildSectionTitle("3. Chi tiết & Hình ảnh"),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller.descController,
                      "Mô tả chi tiết sản phẩm",
                      maxLines: 4,
                    ),
                    const SizedBox(height: 24),
                    _buildImagePickerArea(),
                  ],
                ),
              ),
            ),

            // --- FOOTER (ACTIONS) ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
              ),
              child: _buildDialogActions(),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI COMPONENTS DÀNH RIÊNG CHO DIALOG ---

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.blueAccent,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String label, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
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
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: controller.selectedCategoryId.value,
        decoration: InputDecoration(
          labelText: "Danh mục",
          labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
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

  Widget _buildSizeManager() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.sizeInputController,
                decoration: InputDecoration(
                  hintText: "Nhập size (VD: S, M, XL...)",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
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
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                ),
                onFieldSubmitted: (val) => controller.addSize(val),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () =>
                  controller.addSize(controller.sizeInputController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                elevation: 0,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              child: const Text("Thêm"),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.sizes
                .map(
                  (size) => Chip(
                    label: Text(
                      size,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onDeleted: () => controller.removeSize(size),
                    backgroundColor: Colors.blue.withOpacity(0.05),
                    deleteIconColor: Colors.blueAccent,
                    side: const BorderSide(
                      color: Colors.blueAccent,
                      width: 0.5,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePickerArea() {
    return Obx(
      () => Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
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
          _buildAddImageButton(),
        ],
      ),
    );
  }

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
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isOld
                  ? Colors.blueAccent.withOpacity(0.5)
                  : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: child,
          ),
        ),
        Positioned(
          right: -4,
          top: -4,
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
            onPressed: onRemove,
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ),
        if (isOld)
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: const Text(
                "Cloud",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
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
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_photo_alternate_outlined,
              color: Colors.blueAccent,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              "Thêm ảnh",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            foregroundColor: Colors.grey.shade700,
          ),
          child: const Text(
            "Hủy thao tác",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 12),
        Obx(
          () => ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () => controller.saveProduct(oldProduct: oldProduct),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
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
                      Text(
                        "Đang xử lý... ${(controller.uploadProgress.value * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                : Text(
                    oldProduct == null ? "Thêm sản phẩm" : "Lưu thay đổi",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
