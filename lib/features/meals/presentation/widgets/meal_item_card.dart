import 'package:flutter/material.dart';

import '../../data/models/meal_item_model.dart';

class MealItemCard extends StatelessWidget {
  final MealItemModel item;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const MealItemCard({
    super.key,
    required this.item,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.price.toStringAsFixed(0)} ر.س',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            _buildQuantitySelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantitySelector() {
    if (quantity == 0) {
      return IconButton(
        onPressed: onAdd,
        icon: const Icon(Icons.add_circle_outline),
        color: Colors.green,
        iconSize: 32,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onAdd,
          icon: const Icon(Icons.add_circle),
          color: Colors.green,
          iconSize: 28,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '$quantity',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          onPressed: onRemove,
          icon: const Icon(Icons.remove_circle),
          color: Colors.red,
          iconSize: 28,
        ),
      ],
    );
  }
}
