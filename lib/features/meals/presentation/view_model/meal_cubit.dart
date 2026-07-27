import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/meal_item_model.dart';
import '../../data/models/meal_order_model.dart';
import '../../data/repos/meal_repo.dart';
import 'meal_state.dart';

class MealCubit extends Cubit<MealState> {
  final MealRepository _mealRepo;

  MealCubit(this._mealRepo) : super(MealInitial());

  List<MealItemModel> _menuItems = [];
  Map<String, int> _cartItems = {};

  List<MealItemModel> get menuItems => _menuItems;
  Map<String, int> get cartItems => _cartItems;

  double get cartTotal {
    double total = 0;
    _cartItems.forEach((itemId, quantity) {
      final item = _menuItems.firstWhere((e) => e.id == itemId);
      total += item.price * quantity;
    });
    return total;
  }

  List<MealOrderItem> get cartOrderItems {
    return _cartItems.entries.map((entry) {
      final item = _menuItems.firstWhere((e) => e.id == entry.key);
      return MealOrderItem(
        itemId: item.id,
        name: item.name,
        quantity: entry.value,
        price: item.price,
      );
    }).toList();
  }

  Future<void> loadMenu() async {
    emit(MealLoading());
    final result = await _mealRepo.getMenu();
    result.fold(
      (error) => emit(MealError(error)),
      (items) {
        _menuItems = items;
        emit(MealMenuLoaded(items));
      },
    );
  }

  void addToCart(String itemId) {
    _cartItems[itemId] = (_cartItems[itemId] ?? 0) + 1;
    emit(MealCartUpdated(
      cartItems: Map.from(_cartItems),
      total: cartTotal,
    ));
  }

  void removeFromCart(String itemId) {
    if (_cartItems.containsKey(itemId)) {
      if (_cartItems[itemId]! > 1) {
        _cartItems[itemId] = _cartItems[itemId]! - 1;
      } else {
        _cartItems.remove(itemId);
      }
      emit(MealCartUpdated(
        cartItems: Map.from(_cartItems),
        total: cartTotal,
      ));
    }
  }

  void clearCart() {
    _cartItems.clear();
    emit(MealCartUpdated(
      cartItems: Map.from(_cartItems),
      total: cartTotal,
    ));
  }

  Future<void> submitOrder(String userId, String userName) async {
    if (_cartItems.isEmpty) {
      emit(const MealError('السلة فارغة'));
      return;
    }

    emit(MealOrderSubmitting());

    final order = MealOrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      userName: userName,
      items: cartOrderItems,
      total: cartTotal,
      isPaid: false,
      date: DateTime.now(),
      createdAt: DateTime.now(),
    );

    final result = await _mealRepo.createOrder(order);
    result.fold(
      (error) => emit(MealError(error)),
      (_) {
        _cartItems.clear();
        emit(MealOrderSubmitted());
      },
    );
  }

  Future<void> loadOrders(DateTime date) async {
    emit(MealLoading());
    final result = await _mealRepo.getOrders(date);
    result.fold(
      (error) => emit(MealError(error)),
      (orders) => emit(MealOrdersLoaded(orders)),
    );
  }

  Future<void> updatePaymentStatus(String orderId, bool isPaid) async {
    final result = await _mealRepo.updatePaymentStatus(orderId, isPaid);
    result.fold(
      (error) => emit(MealError(error)),
      (_) => emit(MealPaymentUpdated()),
    );
  }
}
