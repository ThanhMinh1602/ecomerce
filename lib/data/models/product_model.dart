import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String id;
  String name;
  String description;
  double price;
  double? oldPrice;
  double rating;
  int reviewCount;
  int soldCount;
  List<String> sizes;
  List<String> colors; // Thêm trường lưu danh sách mã màu [cite: 2026-03-03]
  List<String> images;
  String categoryId;
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
    required this.soldCount,
    required this.sizes,
    required this.colors, // Yêu cầu danh sách màu khi khởi tạo [cite: 2026-03-03]
    required this.images,
    required this.stock,
    required this.createdAt,
    required this.categoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json, String docId) {
    return ProductModel(
      id: json['id'] ?? docId,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      oldPrice: json['oldPrice']?.toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      soldCount: json['soldCount'] ?? 0,
      sizes: List<String>.from(json['sizes'] ?? []),
      colors: List<String>.from(json['colors'] ?? []), // Parse danh sách màu từ Firestore [cite: 2026-03-03]
      images: List<String>.from(json['images'] ?? []),
      stock: json['stock'] ?? 0,
      categoryId: json['categoryId'] ?? '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'oldPrice': oldPrice,
      'rating': rating,
      'reviewCount': reviewCount,
      'soldCount': soldCount,
      'sizes': sizes,
      'colors': colors, // Lưu danh sách mã màu (0xFF...) lên Firestore [cite: 2026-03-03]
      'images': images,
      'stock': stock,
      'categoryId': categoryId,
      'createdAt': createdAt, // Hoặc FieldValue.serverTimestamp() nếu thêm mới
    };
  }
}