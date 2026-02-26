import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/data/models/product_model.dart';
import 'package:ecomerce/data/models/category_model.dart';
import 'package:ecomerce/data/services/product_service.dart';
import 'package:ecomerce/data/services/category_service.dart';
import 'package:ecomerce/data/services/cloudinary_service.dart';

class AdminProductsController extends BaseController {
  final ProductService productService;
  final CategoryService categoryService;
  final CloudinaryService cloudinaryService;

  AdminProductsController({
    required this.productService,
    required this.categoryService,
    required this.cloudinaryService,
  });

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final oldPriceController = TextEditingController();
  final ratingController = TextEditingController();
  final reviewCountController = TextEditingController();
  final stockController = TextEditingController();
  final sizeInputController = TextEditingController();

  RxList<ProductModel> products = <ProductModel>[].obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxList<String> existingImages = <String>[].obs;
  RxList<String> sizes = <String>[].obs;

  final selectedCategoryId = Rxn<String>();

  var selectedImagesBytes = <Uint8List>[].obs;
  var selectedImageNames = <String>[];
  var uploadProgress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();

    products.bindStream(productService.streamProducts());
    categories.bindStream(categoryService.streamCategories());
  }

  @override
  void onClose() {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    oldPriceController.dispose();
    ratingController.dispose();
    reviewCountController.dispose();
    stockController.dispose();
    sizeInputController.dispose();
    super.onClose();
  }

  void addSize(String size) {
    String cleanSize = size.trim().toUpperCase();
    if (cleanSize.isNotEmpty && !sizes.contains(cleanSize)) {
      sizes.add(cleanSize);
      sizeInputController.clear();
    }
  }

  void removeSize(String size) => sizes.remove(size);

  Future<void> pickMultipleImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(imageQuality: 80);

    if (images.isNotEmpty) {
      for (var image in images) {
        selectedImagesBytes.add(await image.readAsBytes());
        selectedImageNames.add(image.name);
      }
    }
  }

  void removeSelectedImage(int index) {
    selectedImagesBytes.removeAt(index);
    selectedImageNames.removeAt(index);
  }

  void clearFields() {
    nameController.clear();
    descController.clear();
    priceController.clear();
    oldPriceController.clear();
    ratingController.clear();
    reviewCountController.clear();
    stockController.clear();
    sizes.clear();
    existingImages.clear(); // Quan trọng
    selectedImagesBytes.clear();
    selectedImageNames.clear();
    selectedCategoryId.value = null;
    uploadProgress.value = 0.0;
  }

  void prepareEdit(ProductModel product) {
    clearFields();
    nameController.text = product.name; //
    descController.text = product.description; //
    priceController.text = product.price.toString(); //
    oldPriceController.text = product.oldPrice?.toString() ?? ''; //
    ratingController.text = product.rating.toString(); //
    reviewCountController.text = product.reviewCount.toString(); //
    stockController.text = product.stock.toString();
    sizes.addAll(product.sizes); //
    selectedCategoryId.value = product.categoryId;
    existingImages.addAll(product.images); // Đổ ảnh cũ vào đây để quản lý
  }

  void removeExistingImage(int index) => existingImages.removeAt(index);
  Future<void> saveProduct({ProductModel? oldProduct}) async {
    // 1. VALIDATION CHI TIẾT
    if (nameController.text.trim().isEmpty)
      return showWarning("Tên sản phẩm không được để trống!");
    if (selectedCategoryId.value == null)
      return showWarning("Vui lòng chọn danh mục!");

    double price = double.tryParse(priceController.text.trim()) ?? 0;
    if (price <= 0) return showWarning("Giá sản phẩm phải lớn hơn 0!");

    // Check ảnh: ít nhất phải có ảnh cũ hoặc ảnh mới
    if (existingImages.isEmpty && selectedImagesBytes.isEmpty) {
      return showWarning("Vui lòng thêm ít nhất một hình ảnh!");
    }

    showLoading();
    uploadProgress.value = 0.0;

    try {
      // 2. UPLOAD ẢNH MỚI (NẾU CÓ)
      List<String> newUploadedIds = [];
      if (selectedImagesBytes.isNotEmpty) {
        final String folder =
            '/products/${DateTime.now().millisecondsSinceEpoch}';
        newUploadedIds = await cloudinaryService.uploadMultipleImages(
          filesBytes: selectedImagesBytes,
          fileNames: selectedImageNames,
          folder: folder,
          onTotalProgress: (p) => uploadProgress.value = p,
        );
      }

      // 3. TỔNG HỢP DANH SÁCH ẢNH CUỐI CÙNG (Ảnh cũ chưa bị xóa + Ảnh mới)
      List<String> finalImages = [...existingImages, ...newUploadedIds];

      final product = ProductModel(
        id: oldProduct?.id ?? '',
        name: nameController.text.trim(),
        description: descController.text.trim(),
        price: price,
        oldPrice: double.tryParse(oldPriceController.text.trim()), //
        rating: double.tryParse(ratingController.text.trim()) ?? 0.0, //
        reviewCount: int.tryParse(reviewCountController.text.trim()) ?? 0, //
        sizes: sizes.toList(), //
        images: finalImages,
        stock: int.tryParse(stockController.text.trim()) ?? 0,
        categoryId: selectedCategoryId.value!,
        createdAt: oldProduct?.createdAt ?? DateTime.now(),
      );

      // 4. LƯU DATABASE
      if (oldProduct == null) {
        await productService.addProduct(product);
      } else {
        await productService.updateProduct(product.id, product.toJson());
      }

      // 5. ĐÓNG FORM VÀ RESET
      hideLoading();
      Get.back(); // Đảm bảo đóng Dialog thành công [cite: 2026-02-26]
      showSuccess("Đã lưu sản phẩm thành công!");
      clearFields();
    } catch (e) {
      hideLoading();
      showError("Lỗi hệ thống: $e");
    }
  }

  Future<void> deleteProduct(ProductModel product) async {
    showDeleteConfirmDialog(
      itemName: product.name,
      onConfirm: () async {
        showLoading();
        try {
          await productService.deleteProduct(product);
          hideLoading();
          showSuccess("Đã xóa sản phẩm!");
        } catch (e) {
          hideLoading();
          showError("Lỗi khi xóa: $e");
        }
      },
    );
  }
}
