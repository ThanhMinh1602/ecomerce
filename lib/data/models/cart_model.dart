class CartItemModel {
  String id;
  String productId;
  String name;
  String image;
  double price;
  int quantity;
  String? selectedColor;
  String? selectedSize;

  // Thêm biến này để quản lý trạng thái UI (Check/Uncheck)
  bool isSelected;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
    this.selectedColor,
    this.selectedSize,
    this.isSelected = false, // Mặc định là chưa chọn
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json, String docId) {
    return CartItemModel(
      id: docId,
      productId: json['productId'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
      selectedColor: json['selectedColor'],
      selectedSize: json['selectedSize'],
      // Không cần parse isSelected từ JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'selectedColor': selectedColor,
      'selectedSize': selectedSize,
      'addedAt': DateTime.now(),
      // Không đẩy isSelected lên Firebase
    };
  }
}