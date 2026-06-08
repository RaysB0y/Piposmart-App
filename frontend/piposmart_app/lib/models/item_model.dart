// lib/models/item_model.dart
class ItemModel {
  final String id;
  final String name;
  final String? description;
  final int price;
  final String? category;
  final DateTime createdAt;

  ItemModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.category,
    required this.createdAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      price: json['price'] ?? 0,
      category: json['category'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
