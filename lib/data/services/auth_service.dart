import 'package:ecomerce/core/providers/firebase_provider.dart';
import 'package:ecomerce/data/enums/user_role.dart';
import 'package:ecomerce/data/models/user_model.dart';
import 'package:ecomerce/data/services/preferences_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseProvider.auth;
  final FirebaseFirestore _firestore = FirebaseProvider.firestore;

  late Rx<User?> firebaseUser;
  var currentUser = Rxn<UserModel>();

  // Biến cờ để đảm bảo GoogleSignIn chỉ được initialize đúng 1 lần
  bool _isGoogleInitialized = false;

  @override
  void onInit() {
    super.onInit();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  // ==========================================
  // KHỞI TẠO GOOGLE SIGN-IN (API MỚI)
  // ==========================================
  Future<void> _ensureGoogleInitialized() async {
    if (!_isGoogleInitialized) {
      await GoogleSignIn.instance.initialize(
        // ⚠️ QUAN TRỌNG: Dán Web Client ID của bạn vào dòng dưới đây:
        serverClientId: '682314435499-lbs6le72dmvfbjq72aigfiprdihp4h6i.apps.googleusercontent.com',
      );
      _isGoogleInitialized = true;
    }
  }

  Future<void> _setInitialScreen(User? user) async {
    if (user != null) {
      await fetchUserDetails(user.uid);
    } else {
      currentUser.value = null;
    }
  }

  Future<void> fetchUserDetails(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(FirebaseProvider.users)
          .doc(uid)
          .get();

      if (doc.exists) {
        currentUser.value = UserModel.fromJson(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
    } catch (e) {
      print("Lỗi lấy thông tin user: $e");
    }
  }

  Future<bool> updateUser(UserModel updatedUser) async {
    try {
      await _firestore
          .collection(FirebaseProvider.users)
          .doc(updatedUser.id)
          .update(updatedUser.toJson());

      currentUser.value = updatedUser;
      currentUser.refresh();

      return true;
    } catch (e) {
      print("Lỗi cập nhật thông tin user: $e");
      return false;
    }
  }

  Future<bool> loginAdmin(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = credential.user!.uid;

      DocumentSnapshot doc = await _firestore
          .collection(FirebaseProvider.users)
          .doc(uid)
          .get();

      if (doc.exists) {
        UserModel userModel = UserModel.fromJson(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );

        if (userModel.role == UserRole.admin ||
            userModel.role == UserRole.employee) {
          currentUser.value = userModel;
          return true;
        } else {
          await logout();
          print("Tài khoản không có quyền truy cập hệ thống quản trị");
          return false;
        }
      } else {
        await logout();
        print("Không tìm thấy dữ liệu user trên hệ thống");
        return false;
      }
    } catch (e) {
      print("Lỗi đăng nhập quản trị: $e");
      return false;
    }
  }

  Future<bool> loginUser(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = credential.user!.uid;
      await fetchUserDetails(uid);

      return true;
    } catch (e) {
      print("Lỗi đăng nhập user: $e");
      return false;
    }
  }

  Future<bool> registerUser(String email, String password, String name) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = credential.user!.uid;

      UserModel newUser = UserModel(
        id: uid,
        name: name,
        email: email,
        role: UserRole.customer,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection(FirebaseProvider.users)
          .doc(uid)
          .set(newUser.toJson());

      currentUser.value = newUser;

      return true;
    } catch (e) {
      print("Lỗi đăng ký user: $e");
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Đã gửi email reset mật khẩu đến $email");
      return true;
    } catch (e) {
      print("Lỗi gửi mail reset mật khẩu: $e");
      return false;
    }
  }

  // ==========================================
  // ĐĂNG NHẬP MXH (CẬP NHẬT THEO API MỚI)
  // ==========================================

  Future<bool> loginWithGoogle() async {
    try {
      // 1. Khởi tạo cấu hình (chỉ chạy 1 lần)
      await _ensureGoogleInitialized();

      // 2. Xóa session cũ nếu có
      await GoogleSignIn.instance.signOut();

      // 3. Gọi hàm authenticate() thay cho signIn() cũ
      final GoogleSignInAccount account = await GoogleSignIn.instance.authenticate(
        scopeHint: ['email', 'profile'],
      );

      // 4. Lấy Authentication (ID Token)
      final GoogleSignInAuthentication googleAuth = account.authentication;

      // 5. Lấy Authorization (Access Token - lấy âm thầm nếu được)
      final authz = await account.authorizationClient.authorizationForScopes(['email', 'profile']);

      // 6. Cung cấp chứng chỉ cho Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: authz?.accessToken,
      );

      // 7. Đăng nhập Firebase
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // 8. Lưu vào Firestore
      return await _handleSocialLoginResult(userCredential);

    } catch (e) {
      // Trong API mới, nếu user bấm hủy (cancel) popup, nó sẽ throw một GoogleSignInException
      print("Lỗi đăng nhập Google: $e");
      return false;
    }
  }

  Future<bool> loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final AuthCredential credential = FacebookAuthProvider.credential(
          result.accessToken!.tokenString,
        );

        UserCredential userCredential = await _auth.signInWithCredential(credential);

        return await _handleSocialLoginResult(userCredential);
      } else {
        print("Trạng thái đăng nhập Facebook: ${result.status}");
        return false;
      }
    } catch (e) {
      print("Lỗi đăng nhập Facebook: $e");
      return false;
    }
  }

  Future<bool> _handleSocialLoginResult(UserCredential credential) async {
    try {
      User? firebaseUser = credential.user;
      if (firebaseUser == null) return false;

      String uid = firebaseUser.uid;

      DocumentSnapshot doc = await _firestore
          .collection(FirebaseProvider.users)
          .doc(uid)
          .get();

      if (!doc.exists) {
        UserModel newUser = UserModel(
          id: uid,
          name: firebaseUser.displayName ?? "Khách hàng",
          email: firebaseUser.email ?? "",
          role: UserRole.customer,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection(FirebaseProvider.users)
            .doc(uid)
            .set(newUser.toJson());

        currentUser.value = newUser;
      } else {
        await fetchUserDetails(uid);
      }

      return true;
    } catch (e) {
      print("Lỗi xử lý dữ liệu mạng xã hội: $e");
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();

    // Đăng xuất khỏi các session MXH
    try {
      // Đảm bảo Google đã được init trước khi gọi signOut để tránh lỗi null
      await _ensureGoogleInitialized();
      await GoogleSignIn.instance.signOut();
      await FacebookAuth.instance.logOut();
    } catch (e) {
      print("Lỗi khi xóa cache mạng xã hội: $e");
    }

    currentUser.value = null;
    // Clear login preferences
    await PreferencesService().clearLoginData();
  }
}