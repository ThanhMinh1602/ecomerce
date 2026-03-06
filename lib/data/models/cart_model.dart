class CartItemModel {
  String id;
  String productId;
  String name;
  String image;
  double price;
  int quantity;
  String? selectedColor;
  String? selectedSize;
  List<String> availableSizes;
  List<String> availableColors;

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
    this.availableSizes = const [],
    this.availableColors = const [],
    this.isSelected = false,
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
      availableSizes: List<String>.from(json['availableSizes'] ?? []),
      availableColors: List<String>.from(json['availableColors'] ?? []),
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
      'availableSizes': availableSizes,
      'availableColors': availableColors,
      'addedAt': DateTime.now(),
    };
  }

  CartItemModel copyWith({
    String? selectedSize,
    String? selectedColor,
    int? quantity,
  }) {
    return CartItemModel(
      id: id,
      productId: productId,
      name: name,
      image: image,
      price: price,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }
}
