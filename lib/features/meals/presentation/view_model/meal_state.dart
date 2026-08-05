import 'package:equatable/equatable.dart';

import '../../data/models/meal_item_model.dart';
import '../../data/models/meal_order_model.dart';

abstract class MealState extends Equatable {
  const MealState();

  @override
  List<Object?> get props => [];
}

class MealInitial extends MealState {}

class MealLoading extends MealState {}

class MealMenuLoaded extends MealState {
  final List<MealItemModel> menuItems;

  const MealMenuLoaded(this.menuItems);

  @override
  List<Object?> get props => [menuItems];
}

class MealCartUpdated extends MealState {
  final Map<String, int> cartItems;
  final double total;

  const MealCartUpdated({
    required this.cartItems,
    required this.total,
  });

  @override
  List<Object?> get props => [cartItems, total];
}

class MealOrderSubmitting extends MealState {}

class MealOrderSubmitted extends MealState {}

class MealItemSaved extends MealState {}

class MealItemDeleted extends MealState {}

class MealOrdersLoaded extends MealState {
  final List<MealOrderModel> orders;

  const MealOrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class MealPaymentUpdated extends MealState {}

class MealError extends MealState {
  final String message;

  const MealError(this.message);

  @override
  List<Object?> get props => [message];
}
