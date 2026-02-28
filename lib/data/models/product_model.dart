import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String id;
  String name; // Ví dụ: Regular Fit shirt
  String description; // Đoạn mô tả chi tiết
  double price; // Giá hiện tại: $120.00
  double? oldPrice; // Giá cũ: $150.00
  double rating; // Điểm đánh giá: 4.7
  int reviewCount; // Số lượng review: 112
  List<String> sizes; // Danh sách size: S, M, XL, XXL
  List<String> images; // Danh sách public_id từ Cloudinary
  String categoryId; // Danh mục (ví dụ: Men's Jacket)
  int stock;
  DateTime createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviewCount,
    required this.sizes,
    required this.images,
    required this.stock,
    required this.createdAt,
    required this.categoryId,
  });

  // Chuyển đổi từ JSON (Firestore) sang Model
  factory ProductModel.fromJson(Map<String, dynamic> json, String docId) {
    return ProductModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      oldPrice: json['oldPrice']?.toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      sizes: List<String>.from(json['sizes'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      stock: json['stock'] ?? 0,
      categoryId: json['categoryId'] ?? '',
      // Xử lý lỗi null của Timestamp mà chúng ta đã gặp
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  // Chuyển đổi từ Model sang JSON để lưu lên Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'oldPrice': oldPrice,
      'rating': rating,
      'reviewCount': reviewCount,
      'sizes': sizes,
      'images': images,
      'stock': stock,
      'categoryId': categoryId,
      'createdAt': FieldValue.serverTimestamp(), // Dùng thời gian server
    };
  }
}
