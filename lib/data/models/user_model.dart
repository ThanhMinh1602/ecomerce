import 'package:ecomerce/data/enums/user_role.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 

class UserModel {
  String id;
  String name;
  String email;
  UserRole role;
  String? phone;
  String? avatar; 
  List<String> addresses;
  

  DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role = UserRole.customer,
    this.phone,
    this.avatar,
    this.addresses = const [], 
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String documentId) {
    return UserModel(
      id: documentId,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: UserRole.fromString(json['role'] ?? ''),
      phone: json['phone'],
      avatar: json['avatar'],

      
      addresses: json['addresses'] != null
          ? List<String>.from(json['addresses'])
          : [],

      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role.value,
      'phone': phone,

      
      'avatar': avatar,
      'addresses': addresses,

      'createdAt': createdAt,
    };
  }
}