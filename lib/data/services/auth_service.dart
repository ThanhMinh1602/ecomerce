import 'package:ecomerce/core/providers/firebase_provider.dart';
import 'package:ecomerce/data/enums/user_role.dart';
import 'package:ecomerce/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseProvider.auth;
  final FirebaseFirestore _firestore = FirebaseProvider.firestore;

  late Rx<User?> firebaseUser;
  var currentUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
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

  Future<void> logout() async {
    await _auth.signOut();
    currentUser.value = null;
  }
}
