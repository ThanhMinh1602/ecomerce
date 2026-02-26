import 'package:ecomerce/data/enums/user_role.dart';

class UserModel {
  String id;
  String name;
  String email;
  UserRole role; // Đổi sang kiểu Enum
  String? phone;
  DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role = UserRole.customer,
    this.phone,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String documentId) {
    return UserModel(
      id: documentId,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      // Dùng hàm fromString để parse dữ liệu từ Firebase về Enum
      role: UserRole.fromString(json['role'] ?? ''),
      phone: json['phone'],
      createdAt: json['createdAt'] != null
          ? json['createdAt'].toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role.value,
      'phone': phone,
      'createdAt': createdAt,
    };
  }
}
