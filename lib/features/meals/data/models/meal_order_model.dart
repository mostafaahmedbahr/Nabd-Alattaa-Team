import 'package:equatable/equatable.dart';

class MealOrderItem extends Equatable {
  final String itemId;
  final String name;
  final int quantity;
  final double price;

  const MealOrderItem({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  double get subtotal => quantity * price;

  factory MealOrderItem.fromMap(Map<String, dynamic> map) {
    return MealOrderItem(
      itemId: map['itemId'] ?? '',
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: (map['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }

  @override
  List<Object?> get props => [itemId, name, quantity, price];
}

class MealOrderModel extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final List<MealOrderItem> items;
  final double total;
  final bool isPaid;
  final DateTime date;
  final DateTime createdAt;

  const MealOrderModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.items,
    required this.total,
    required this.isPaid,
    required this.date,
    required this.createdAt,
  });

  factory MealOrderModel.fromMap(Map<String, dynamic> map) {
    return MealOrderModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      items: (map['items'] as List<dynamic>?)
              ?.map((e) => MealOrderItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: (map['total'] ?? 0).toDouble(),
      isPaid: map['isPaid'] ?? false,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] ?? 0),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'items': items.map((e) => e.toMap()).toList(),
      'total': total,
      'isPaid': isPaid,
      'date': date.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  @override
  List<Object?> get props =>
      [id, userId, userName, items, total, isPaid, date, createdAt];
}
