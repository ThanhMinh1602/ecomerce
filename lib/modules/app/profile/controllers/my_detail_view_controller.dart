import 'package:ecomerce/core/base/base_controller.dart';
import 'package:ecomerce/core/mixins/user_mixin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MyDetailViewController extends BaseController with UserMixin {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  final formKey = GlobalKey<FormState>();

  late final TextEditingController newAddressController;

  RxBool isAddingAddress = false.obs;
  RxnInt editingIndex = RxnInt();
  RxBool isFetchingLocation = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: userName);
    emailController = TextEditingController(text: userEmail);
    phoneController = TextEditingController(text: userPhone);
    newAddressController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
    if (Get.arguments == true) {
      Future.delayed(const Duration(milliseconds: 300), () {
        toggleAddingAddress();
      });
    }
  }

  void toggleAddingAddress() async {
    editingIndex.value = null;
    isAddingAddress.value = !isAddingAddress.value;

    if (isAddingAddress.value) {
      newAddressController.clear();
      await _fetchCurrentLocation();
    } else {
      newAddressController.clear();
    }
  }

  void editAddress(int index) {
    editingIndex.value = index;
    isAddingAddress.value = true;

    final user = authService.currentUser.value;
    if (user != null) {
      newAddressController.text = user.addresses[index];
    }
  }

  Future<void> _fetchCurrentLocation() async {
    isFetchingLocation.value = true;
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showError('Quyền vị trí bị từ chối');
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        newAddressController.text =
            '${place.street}, ${place.subAdministrativeArea}, ${place.administrativeArea}';
      }
    } catch (e) {
      print("Lỗi lấy vị trí: $e");
      showError('Không thể lấy vị trí hiện tại');
    } finally {
      isFetchingLocation.value = false;
    }
  }

  Future<void> updateProfile() async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }

    final user = authService.currentUser.value;
    if (user != null) {
      isLoading.value = true;
      user.name = nameController.text.trim();
      user.phone = phoneController.text.trim();

      bool success = await authService.updateUser(user);
      isLoading.value = false;

      if (success) {
        Get.back(result: true);
      } else {
        showError('Có lỗi xảy ra, vui lòng thử lại');
      }
    }
  }

  void saveNewAddress() async {
    final newAddress = newAddressController.text.trim();
    if (newAddress.isEmpty) {
      showError('Address cannot be empty');
      return;
    }

    final user = authService.currentUser.value;
    if (user != null) {
      if (editingIndex.value != null) {
        user.addresses[editingIndex.value!] = newAddress;
      } else {
        user.addresses.add(newAddress);
      }

      isLoading.value = true;
      await authService.updateUser(user);
      isLoading.value = false;
    }

    newAddressController.clear();
    isAddingAddress.value = false;
    editingIndex.value = null;
  }

  Future<void> deleteAddress(int index) async {
    final user = authService.currentUser.value;
    if (user != null) {
      // 1. Tạo một bản sao (Growable List) từ danh sách cũ
      List<String> mutableAddresses = List<String>.from(user.addresses);

      // 2. Xóa trên bản sao
      mutableAddresses.removeAt(index);

      // 3. Gán lại cho user
      user.addresses = mutableAddresses;

      if (editingIndex.value == index) {
        editingIndex.value = null;
        isAddingAddress.value = false;
      }

      isLoading.value = true;

      await authService.updateUser(user);
      isLoading.value = false;

      showSuccess('Đã xóa địa chỉ');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    newAddressController.dispose();
    super.onClose();
  }
}
