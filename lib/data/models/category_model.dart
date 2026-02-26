import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String id;
  String name;
  String? imageUrl; // URL từ Cloudinary
  DateTime createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.createdAt,
  });
  factory CategoryModel.fromJson(Map<String, dynamic> json, String docId) {
    return CategoryModel(
      id: docId,
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
