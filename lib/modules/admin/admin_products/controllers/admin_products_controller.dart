import 'dart:typed_data';
import 'package:ecomerce/core/utils/app_utils.dart';
import 'package:ecomerce/core/utils/validator_util.dart';
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
  final sizeInputController = TextEditingController(text: 's,m,l,xl,xxl');
  final colorInputController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RxList<ProductModel> products = <ProductModel>[].obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxList<String> existingImages = <String>[].obs;
  RxList<String> sizes = <String>[].obs;

  final selectedCategoryId = Rxn<String>();

  var selectedImagesBytes = <Uint8List>[].obs;
  var selectedImageNames = <String>[];
  var uploadProgress = 0.0.obs;
  final RxString currentTab = 'Best seller'.obs;

  RxList<String> colors = <String>[
    '0xFF000000',
    '0xFFFFFFFF',
    '0xFF808080',
    '0xFFF27A24',
  ].obs;

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
    colorInputController.dispose();
    super.onClose();
  }

  void addColors(String input) {
    if (input.trim().isEmpty) return;

    List<String> rawInputs = input.split(',');
    List<String> invalidColors = [];

    for (var raw in rawInputs) {
      String item = raw.trim();

      String? error = ValidatorUtil.validateHexColor(item);

      if (error == null) {
        String clean = item
            .toUpperCase()
            .replaceAll('#', '')
            .replaceAll('0X', '');
        if (clean.length == 6) clean = '0xFF$clean';
        if (!clean.startsWith('0X')) clean = '0xFF$clean';

        if (!colors.contains(clean)) {
          colors.add(clean);
        }
      } else {
        invalidColors.add(item);
      }
    }

    if (invalidColors.isNotEmpty) {
      showWarning("Mã không hợp lệ: ${invalidColors.join(', ')}");
    }

    colorInputController.clear();
  }

  void removeColor(String color) => colors.remove(color);

  void addSize(String input) {
    if (input.trim().isEmpty) return;

    List<String> rawSizes = input.split(',');

    for (var s in rawSizes) {
      String cleanSize = s.trim().toUpperCase();

      if (cleanSize.isNotEmpty && !sizes.contains(cleanSize)) {
        sizes.add(cleanSize);
      }
    }
  }

  void removeSize(String size) => sizes.remove(size);

  Future<void> pickMultipleImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(imageQuality: 80);

    if (images.isNotEmpty) {
      int currentTotal = existingImages.length + selectedImagesBytes.length;
      int allowedToAdd = 6 - currentTotal;

      if (allowedToAdd <= 0) {
        showWarning("Bạn chỉ được phép tải lên tối đa 6 hình ảnh!");
        return;
      }

      Iterable<XFile> imagesToAdd = images.take(allowedToAdd);

      if (images.length > allowedToAdd) {
        showWarning(
          "Đã đạt giới hạn 6 ảnh. Chỉ thêm được $allowedToAdd ảnh mới!",
        );
      }

      for (var image in imagesToAdd) {
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
    stockController.clear();
    sizes.clear();
    colors.clear();
    existingImages.clear();
    selectedImagesBytes.clear();
    selectedImageNames.clear();
    selectedCategoryId.value = null;
    uploadProgress.value = 0.0;

    colors.addAll(['0xFF000000', '0xFFFFFFFF', '0xFF808080', '0xFFF27A24']);
  }

  void prepareEdit(ProductModel product) {
    clearFields();
    nameController.text = product.name;
    descController.text = product.description;
    priceController.text = product.price.toString();
    oldPriceController.text = product.oldPrice?.toString() ?? '';
    stockController.text = product.stock.toString();

    sizes.assignAll(product.sizes);
    colors.assignAll(product.colors);

    selectedCategoryId.value = product.categoryId;
    existingImages.assignAll(product.images);
  }

  void removeExistingImage(int index) => existingImages.removeAt(index);

  Future<void> saveProduct({ProductModel? oldProduct}) async {
    if (!formKey.currentState!.validate()) {
      showWarning("Vui lòng kiểm tra lại các thông tin báo đỏ!");
      return;
    }

    if (selectedCategoryId.value == null) {
      return showWarning("Vui lòng chọn danh mục sản phẩm!");
    }

    if (sizes.isEmpty || colors.isEmpty) {
      return showWarning("Vui lòng thêm ít nhất một Size và một Màu sắc!");
    }

    int totalImages = existingImages.length + selectedImagesBytes.length;
    if (totalImages == 0) {
      return showWarning("Vui lòng thêm ít nhất một hình ảnh!");
    }

    showLoading();
    uploadProgress.value = 0.0;

    try {
      final String uuid = oldProduct?.id ?? AppUtils.generateId();
      List<String> newUploadedIds = [];

      if (selectedImagesBytes.isNotEmpty) {
        final String folder = 'products/$uuid';

        newUploadedIds = await cloudinaryService.uploadMultipleImages(
          filesBytes: selectedImagesBytes,
          fileNames: selectedImageNames,
          folder: folder,
        );
      }

      List<String> finalImages = [...existingImages, ...newUploadedIds];

      final product = ProductModel(
        id: uuid,
        name: nameController.text.trim(),
        description: descController.text.trim(),
        price: double.parse(priceController.text.trim()),
        oldPrice: double.tryParse(oldPriceController.text.trim()),

        rating: oldProduct?.rating ?? 0.0,
        reviewCount: oldProduct?.reviewCount ?? 0,
        soldCount: oldProduct?.soldCount ?? 0,
        sizes: sizes.toList(),
        colors: colors.toList(),

        images: finalImages,
        stock: int.parse(stockController.text.trim()),
        categoryId: selectedCategoryId.value!,
        createdAt: oldProduct?.createdAt ?? DateTime.now(),
      );

      if (oldProduct == null) {
        await productService.addProduct(product);
      } else {
        await productService.updateProduct(product.id, product.toJson());
      }

      hideLoading();
      Get.back();
      clearFields();
    } catch (e) {
      hideLoading();
      showError("Lỗi khi lưu sản phẩm: $e");
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
