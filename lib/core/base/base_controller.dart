import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseController extends GetxController {
  // Trạng thái loading chung
  RxBool isLoading = false.obs;

  void showLoading() {
    isLoading.value = true;
  }

  void hideLoading() {
    isLoading.value = false;
  }

  // ==========================================
  // 1. CÁC HÀM HIỂN THỊ THÔNG BÁO (GÓC TRÊN BÊN PHẢI)
  // ==========================================

  void showSuccess(String message, {String title = 'Thành công'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      maxWidth: 400, // Giới hạn chiều rộng để giống dạng Toast trên Web
      margin: const EdgeInsets.only(
        top: 24,
        right: 24,
      ), // Đẩy về góc trên bên phải
      borderRadius: 8,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
      isDismissible: true,
      animationDuration: const Duration(milliseconds: 400),
    );
  }

  void showError(String message, {String title = 'Lỗi'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.redAccent.shade700,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      maxWidth: 400,
      margin: const EdgeInsets.only(top: 24, right: 24),
      borderRadius: 8,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      duration: const Duration(seconds: 4),
      isDismissible: true,
      animationDuration: const Duration(milliseconds: 400),
    );
  }

  void showWarning(String message, {String title = 'Cảnh báo'}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.orange.shade700,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      maxWidth: 400,
      margin: const EdgeInsets.only(top: 24, right: 24),
      borderRadius: 8,
      icon: const Icon(Icons.warning_amber_outlined, color: Colors.white),
      duration: const Duration(seconds: 3),
      isDismissible: true,
      animationDuration: const Duration(milliseconds: 400),
    );
  }

  // ==========================================
  // 2. CÁC HÀM HIỂN THỊ DIALOG XÁC NHẬN (Giữ nguyên dạng hộp thoại)
  // ==========================================

  /// Dialog Xác nhận hành động (Ví dụ: Bạn có chắc muốn xóa?)
  void showConfirmDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String textConfirm = 'Xác nhận',
    String textCancel = 'Hủy',
    Color confirmColor = Colors.blueAccent,
  }) {
    Get.defaultDialog(
      title: title,
      titlePadding: const EdgeInsets.only(top: 20, bottom: 10),
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      middleText: message,
      middleTextStyle: const TextStyle(fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      radius: 12,
      backgroundColor: Colors.white,
      textConfirm: textConfirm,
      confirmTextColor: Colors.white,
      buttonColor: confirmColor,
      onConfirm: () {
        Get.back();
        onConfirm();
      },

      textCancel: textCancel,
      cancelTextColor: Colors.black87,
      onCancel: () {},
    );
  }

  /// Dialog Cảnh báo xóa
  void showDeleteConfirmDialog({
    required String itemName,
    required VoidCallback onConfirm,
  }) {
    showConfirmDialog(
      title: 'Xác nhận xóa',
      message:
          'Bạn có chắc chắn muốn xóa "$itemName" không? Hành động này không thể hoàn tác.',
      textConfirm: 'Xóa',
      confirmColor: Colors.redAccent,
      onConfirm: onConfirm,
    );
  }
}
