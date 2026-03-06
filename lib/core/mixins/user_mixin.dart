import 'package:ecomerce/data/models/user_model.dart';
import 'package:ecomerce/data/services/auth_service.dart';
import 'package:ecomerce/routes/app_router.dart';
import 'package:get/get.dart';

mixin UserMixin {
  AuthService get authService => Get.find<AuthService>();

  Rxn<UserModel> get rxUser => authService.currentUser;

  UserModel? get currentUser => authService.currentUser.value;

  bool get isLoggedIn => currentUser != null;

  String get userId => currentUser?.id ?? '';

  String get userName => currentUser?.name ?? 'Guest';

  String get userEmail => currentUser?.email ?? '';

  String get userPhone => currentUser?.phone ?? 'Chưa cập nhật số điện thoại';

  String? get userAvatar => currentUser?.avatar;

  List<String> get userAddresses => currentUser?.addresses ?? [];

  String get defaultAddress =>
      userAddresses.isNotEmpty ? userAddresses.first : '';

  bool get hasAddress => userAddresses.isNotEmpty;

  Future<void> logout() async {
    await authService.logout();
    Get.offAllNamed(AppRouter.login);
  }
}
