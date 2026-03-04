import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:ecomerce/core/components/card/custom_card.dart'; // [cite: 2026-03-03]
import 'package:ecomerce/core/components/text_field/custom_text_field.dart'; // [cite: 2026-03-03]
import 'package:ecomerce/core/constants/app_color.dart';
import 'package:ecomerce/core/constants/app_style.dart';
import 'package:ecomerce/core/utils/validator_util.dart';
import 'package:ecomerce/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_products_controller.dart';

class ProductFormDialog extends GetView<AdminProductsController> {
  final ProductModel? oldProduct;

  const ProductFormDialog({super.key, this.oldProduct});

  @override
  Widget build(BuildContext context) {
    // Nếu là chế độ edit, thực hiện load dữ liệu cũ vào controller [cite: 2026-03-03]
    if (oldProduct != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.prepareEdit(oldProduct!);
      });
    }

    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 850,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        // Sử dụng Form để quản lý validate toàn bộ bằng formKey [cite: 2026-03-03]
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              _buildHeader(),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // --- PHẦN 1: THÔNG TIN CƠ BẢN ---
                      CustomCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle("1. Thông tin cơ bản"),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: controller.nameController,
                           hintText: "Ví dụ: Korean style Men's Combo", // [cite: 36]
                              labelText: "Tên sản phẩm",
                              validator: (val) => ValidatorUtil.validateLength(val, "Tên", 5, 100),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(child: _buildCategoryDropdown()),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CustomTextField(
                                    controller: controller.stockController,
                                    hintText: "0",
                                    labelText: "Số lượng kho",
                                    isNumber: true,
                                    validator: (val) => ValidatorUtil.validateStock(val),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- PHẦN 2: ĐỊNH GIÁ & BIẾN THỂ ---
                      CustomCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle("2. Định giá & Phân loại"),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: controller.priceController,
                                  hintText: "120.00", // [cite: 37]
                                    labelText: "Giá bán hiện tại (USD)",
                                    isNumber: true,
                                    validator: (val) => ValidatorUtil.validatePrice(val),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CustomTextField(
                                    controller: controller.oldPriceController,
                                    hintText: "150.00", // [cite: 38]
                                    labelText: "Giá gốc (Để gạch ngang)",
                                    isNumber: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildSizeManager(), // Nhập size bằng dấu phẩy [cite: 2026-03-03]
                            const SizedBox(height: 24),
                            _buildColorManager(), // Nhập mã màu 0xFF bằng dấu phẩy [cite: 2026-03-03]
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- PHẦN 3: CHI TIẾT & HÌNH ẢNH ---
                      CustomCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle("3. Hình ảnh & Mô tả"),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: controller.descController,
                              hintText: "Mô tả chi tiết sản phẩm...",
                              labelText: "Mô tả",
                              maxLines: 4,
                              validator: (val) => ValidatorUtil.validateEmpty(val, "Mô tả"),
                            ),
                            const SizedBox(height: 24),
                            _buildImagePickerArea(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            oldProduct == null ? "Thêm sản phẩm mới" : "Cập nhật sản phẩm",
            style: AppStyle.smallContentBold.copyWith(fontSize: 20),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppStyle.smallContentBold.copyWith(color: AppColor.orange500),
    );
  }

  Widget _buildCategoryDropdown() {
    return Obx(() => DropdownButtonFormField<String>(
      value: controller.selectedCategoryId.value,
      validator: (val) => ValidatorUtil.validateEmpty(val, "Danh mục"),
      decoration: InputDecoration(
        labelText: "Danh mục",
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: controller.categories.map((cat) => DropdownMenuItem(value: cat.name, child: Text(cat.name))).toList(),
      onChanged: (val) => controller.selectedCategoryId.value = val,
    ));
  }

  Widget _buildSizeManager() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Kích thước (Sizes)", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
            child: CustomTextField(
              controller: controller.sizeInputController,
              hintText: "S, M, L, XL...",
              labelText: "",
              onFieldSubmitted: (val) => controller.addSize(val), // Logic tách dấu phẩy [cite: 2026-03-03]
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => controller.addSize(controller.sizeInputController.text),
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.orange500),
            child: const Text("THÊM", style: TextStyle(color: Colors.white)),
          ),
        ]),
        const SizedBox(height: 12),
        Obx(() => Wrap(
          spacing: 8,
          children: controller.sizes.map((s) => Chip(
            label: Text(s),
            onDeleted: () => controller.removeSize(s),
            backgroundColor: AppColor.orange500.withOpacity(0.1),
            deleteIconColor: AppColor.orange500,
          )).toList(),
        )),
      ],
    );
  }

  Widget _buildColorManager() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Màu sắc (Colors)", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text("Nhập mã màu (VD: FFFFFF hoặc 0xFF...) cách nhau bởi dấu phẩy.", style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: CustomTextField(
              controller: controller.colorInputController,
              hintText: "0xFF000000, FFFFFF...",
              labelText: "",
              onFieldSubmitted: (val) => controller.addColors(val), // Logic auto 0xFF [cite: 2026-03-03]
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => controller.addColors(controller.colorInputController.text),
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.orange500),
            child: const Text("THÊM", style: TextStyle(color: Colors.white)),
          ),
        ]),
        const SizedBox(height: 12),
        Obx(() => Wrap(
          spacing: 12,
          children: controller.colors.map((c) => Chip(
            avatar: CircleAvatar(
              radius: 10,
              backgroundColor: Color(int.parse(c)), // Hiển thị preview màu từ mã Hex [cite: 2026-03-03]
            ),
            label: Text(c, style: const TextStyle(fontSize: 10, fontFamily: 'monospace')),
            onDeleted: () => controller.removeColor(c),
          )).toList(),
        )),
      ],
    );
  }

  Widget _buildImagePickerArea() {
    return Obx(() => Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        ...List.generate(controller.existingImages.length, (index) => _buildThumbnail(
          child: CldImageWidget(publicId: controller.existingImages[index], fit: BoxFit.cover),
          onRemove: () => controller.removeExistingImage(index),
          isCloud: true,
        )),
        ...List.generate(controller.selectedImagesBytes.length, (index) => _buildThumbnail(
          child: Image.memory(controller.selectedImagesBytes[index], fit: BoxFit.cover),
          onRemove: () => controller.removeSelectedImage(index),
        )),
        _buildAddButton(),
      ],
    ));
  }

  Widget _buildThumbnail({required Widget child, required VoidCallback onRemove, bool isCloud = false}) {
    return Stack(
      children: [
        Container(
          width: 100, height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isCloud ? AppColor.orange500 : Colors.grey.shade300, width: 1.5),
          ),
          child: ClipRRect(borderRadius: BorderRadius.circular(10), child: child),
        ),
        Positioned(
          right: -4, top: -4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: controller.pickMultipleImages,
      child: Container(
        width: 100, height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
        ),
        child: const Icon(Icons.add_a_photo_outlined, color: AppColor.orange500, size: 28),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("HỦY BỎ", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value ? null : () => controller.saveProduct(oldProduct: oldProduct),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.orange500,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: controller.isLoading.value
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(oldProduct == null ? "THÊM SẢN PHẨM" : "LƯU THAY ĐỔI", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )),
        ],
      ),
    );
  }
}