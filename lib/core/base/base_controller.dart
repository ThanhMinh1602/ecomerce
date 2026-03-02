import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseController extends GetxController {
  RxBool isLoading = false.obs;

  void showLoading() {
    isLoading.value = true;
  }

  void hideLoading() {
    isLoading.value = false;
  }

  void showSuccess(String message, {String? title}) {
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.white, size: 24),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title != null ? '$title - $message' : message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF00E676),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.only(top: 40, left: 24, right: 24),
      borderRadius: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      duration: const Duration(seconds: 3),
      isDismissible: true,
      animationDuration: const Duration(milliseconds: 400),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  void showError(String message, {String? title}) {
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 24),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title != null ? '$title - $message' : message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.redAccent.shade700,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.only(top: 40, left: 24, right: 24),
      borderRadius: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      duration: const Duration(seconds: 4),
      isDismissible: true,
      animationDuration: const Duration(milliseconds: 400),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  void showWarning(String message, {String? title}) {
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.warning_amber_outlined,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              title != null ? '$title - $message' : message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.orange.shade600,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.only(top: 40, left: 24, right: 24),
      borderRadius: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      duration: const Duration(seconds: 3),
      isDismissible: true,
      animationDuration: const Duration(milliseconds: 400),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

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
