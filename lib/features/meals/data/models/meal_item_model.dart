import 'package:equatable/equatable.dart';

class MealItemModel extends Equatable {
  final String id;
  final String name;
  final double price;
  final String category;
  final bool isAvailable;

  const MealItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.isAvailable,
  });

  factory MealItemModel.fromMap(Map<String, dynamic> map) {
    return MealItemModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      category: map['category'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'isAvailable': isAvailable,
    };
  }

  @override
  List<Object?> get props => [id, name, price, category, isAvailable];
}
