import 'package:flutter/material.dart';

class ProductModel {
  final String id;
  final String title;
  final String category;
  final double price;
  final double oldPrice; // 1. Thêm giá cũ
  final String mainImage;
  final List<String> images;
  final String description;
  final String material;
  final List<String> color;
  final List<String> size;
  final double ratingStar;

  ProductModel({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.oldPrice, // Required
    required this.mainImage,
    required this.images,
    required this.description,
    required this.material,
    required this.color,
    required this.size,
    required this.ratingStar,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      oldPrice: (json['oldPrice'] ?? 0).toDouble(), // Parse oldPrice
      mainImage: json['mainImage'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      description: json['description'] ?? '',
      material: json['material'] ?? '',
      color: List<String>.from(json['color'] ?? []),
      size: List<String>.from(json['size'] ?? []),
      ratingStar: (json['ratingStar'] ?? 0).toDouble(),
    );
  }

  // --- 2. HÀM XỬ LÝ MÀU SẮC ---

  // Hàm chuyển đổi mã Hex string (#BA2727) thành Color object
  static Color hexToColor(String hexCode) {
    final buffer = StringBuffer();
    if (hexCode.length == 6 || hexCode.length == 7) buffer.write('ff');
    buffer.write(hexCode.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  // Hàm lấy màu dựa trên tên (Map về 4 màu bạn yêu cầu)
  static Color getColorFromName(String colorName) {
    String name = colorName.toLowerCase();

    if (name.contains('red') ||
        name.contains('burgundy') ||
        name.contains('pink')) {
      return hexToColor('#BA2727');
    } else if (name.contains('black') ||
        name.contains('grey') ||
        name.contains('dark')) {
      return hexToColor('#000000');
    } else if (name.contains('white') || name.contains('silver')) {
      return hexToColor('#F6E9E9');
    } else if (name.contains('yellow') ||
        name.contains('brown') ||
        name.contains('tea') ||
        name.contains('khaki')) {
      return hexToColor('#D5911A');
    }

    // Mặc định trả về màu đen hoặc màu đầu tiên trong list của bạn
    return hexToColor('#000000');
  }

  // --- DATA FAKE (Đã update oldPrice) ---
  static List<ProductModel> dummyProducts = [
    ProductModel(
      id: 'p001',
      title: 'Basic Cotton T-Shirt',
      category: 'Men\'s Tops',
      price: 18.00,
      oldPrice: 25.00, // Giá gốc
      mainImage:
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500',
      images: [
        'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500',
        'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=500',
      ],
      description:
          'Basic plain t-shirt, excellent sweat absorption, suitable for daily wear.',
      material: '100% Cotton',
      color: ['White', 'Black', 'Grey'],
      size: ['S', 'M', 'L', 'XL'],
      ratingStar: 4.8,
    ),
    ProductModel(
      id: 'p002',
      title: 'Khaki Bomber Jacket',
      category: 'Jackets',
      price: 55.00,
      oldPrice: 75.00,
      mainImage:
          'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=500',
      images: [
        'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=500',
      ],
      description:
          'Youthful style bomber jacket, made of thick and durable Khaki material.',
      material: 'Khaki',
      color: ['Moss Green', 'Black'],
      size: ['M', 'L', 'XL'],
      ratingStar: 4.5,
    ),
    ProductModel(
      id: 'p003',
      title: 'Vintage Floral Dress',
      category: 'Women\'s Dresses',
      price: 35.50,
      oldPrice: 50.00,
      mainImage:
          'https://images.unsplash.com/photo-1612336307429-8a898d10e223?w=500',
      images: [
        'https://images.unsplash.com/photo-1612336307429-8a898d10e223?w=500',
      ],
      description:
          'One-piece dress with small floral pattern, gentle vintage style.',
      material: 'Chiffon',
      color: ['Pink', 'Light Blue'],
      size: ['S', 'M'],
      ratingStar: 4.9,
    ),

    ProductModel(
      id: 'p005',
      title: 'Sporty Sneakers',
      category: 'Footwear',
      price: 95.00,
      oldPrice: 120.00,
      mainImage:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
      images: [
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
        'https://images.unsplash.com/photo-1607522370275-f14206abe5d3?w=500',
      ],
      description:
          'Comfortable sneakers with soft soles, perfect for jogging and hanging out.',
      material: 'Mesh fabric & Rubber',
      color: ['Red', 'White'],
      size: ['39', '40', '41', '42'],
      ratingStar: 5.0,
    ),
    ProductModel(
      id: 'p006',
      title: 'Leather Crossbody Bag',
      category: 'Accessories',
      price: 58.00,
      oldPrice: 80.00,
      mainImage:
          'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=500',
      images: [
        'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=500',
      ],
      description: 'Premium synthetic leather bag with a luxurious design.',
      material: 'PU Leather',
      color: ['Brown', 'Black'],
      size: ['FreeSize'],
      ratingStar: 4.6,
    ),
    ProductModel(
      id: 'p007',
      title: 'Unisex Baseball Cap',
      category: 'Accessories',
      price: 15.00,
      oldPrice: 22.00,
      mainImage:
          'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=500',
      images: [
        'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=500',
      ],
      description: 'Street style baseball cap with an adjustable back strap.',
      material: 'Khaki',
      color: ['Black', 'White', 'Yellow'],
      size: ['FreeSize'],
      ratingStar: 4.3,
    ),
    ProductModel(
      id: 'p008',
      title: 'Office Dress Shirt',
      category: 'Men\'s Tops',
      price: 32.00,
      oldPrice: 45.00,
      mainImage:
          'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=500',
      images: [
        'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=500',
      ],
      description:
          'Long sleeve shirt, wrinkle-resistant, suitable for the office environment.',
      material: 'Silk Blend',
      color: ['White', 'Blue'],
      size: ['M', 'L', 'XL'],
      ratingStar: 4.7,
    ),
    ProductModel(
      id: 'p009',
      title: 'Luxury Evening Gown',
      category: 'Women\'s Dresses',
      price: 120.00,
      oldPrice: 180.00,
      mainImage:
          'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=500',
      images: [
        'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=500',
      ],
      description:
          'Evening gown with a slit design, featuring hand-attached stones.',
      material: 'Satin Silk',
      color: ['Burgundy', 'Black'],
      size: ['S', 'M', 'L'],
      ratingStar: 5.0,
    ),
    ProductModel(
      id: 'p010',
      title: 'Fashion Sunglasses',
      category: 'Accessories',
      price: 25.00,
      oldPrice: 35.00,
      mainImage:
          'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=500',
      images: [
        'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=500',
      ],
      description:
          'UV protection sunglasses with a durable flexible plastic frame.',
      material: 'Plastic & Glass',
      color: ['Black', 'Tea Brown'],
      size: ['FreeSize'],
      ratingStar: 4.4,
    ),
  ];
}
