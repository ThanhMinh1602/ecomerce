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

  Future<bool> loginAdmin(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(email);
      print(password);

      String uid = credential.user!.uid;

      DocumentSnapshot doc = await _firestore
          .collection(FirebaseProvider.users)
          .doc(uid)
          .get();

      if (doc.exists) {
        String? roleString = doc.get('role');
        UserRole currentRole = UserRole.fromString(roleString ?? '');

        if (currentRole == UserRole.admin || currentRole == UserRole.employee) {
          currentUser.value = UserModel.fromJson(
            doc.data() as Map<String, dynamic>,
            doc.id,
          );
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
      print("Lỗi đăng nhập: $e");
      return false;
    }
  }

  Future<void> logout() async => await _auth.signOut();
}
