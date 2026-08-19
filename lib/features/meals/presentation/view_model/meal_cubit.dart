import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../../data/models/meal_item_model.dart';
import '../../data/models/meal_order_model.dart';
import '../../data/repos/meal_repo.dart';
import 'meal_state.dart';

class MealCubit extends Cubit<MealState> {
  final MealRepository _mealRepo;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MealCubit(this._mealRepo) : super(MealInitial());

  List<MealItemModel> _menuItems = [];
  List<MealOrderModel> _orders = [];
  final Map<String, int> _cartItems = {};

  List<MealItemModel> get menuItems => _menuItems;
  List<MealOrderModel> get orders => _orders;
  Map<String, int> get cartItems => _cartItems;

  double get cartTotal {
    double total = 0;
    _cartItems.forEach((itemId, quantity) {
      for (final item in _menuItems) {
        if (item.id == itemId) {
          total += item.price * quantity;
          break;
        }
      }
    });
    return total;
  }

  List<MealOrderItem> get cartOrderItems {
    final result = <MealOrderItem>[];
    _cartItems.forEach((itemId, quantity) {
      for (final item in _menuItems) {
        if (item.id == itemId) {
          result.add(
            MealOrderItem(
              itemId: item.id,
              name: item.name,
              quantity: quantity,
              price: item.price,
            ),
          );
          break;
        }
      }
    });
    return result;
  }

  Future<void> loadMenu() async {
    emit(MealLoading());
    final result = await _mealRepo.getMenu();
    result.fold((error) => emit(MealError(error)), (items) {
      _menuItems = items;
      emit(MealMenuLoaded(items));
    });
  }

  void addToCart(String itemId) {
    _cartItems[itemId] = (_cartItems[itemId] ?? 0) + 1;
    emit(MealCartUpdated(cartItems: Map.from(_cartItems), total: cartTotal));
  }

  void removeFromCart(String itemId) {
    if (_cartItems.containsKey(itemId)) {
      if (_cartItems[itemId]! > 1) {
        _cartItems[itemId] = _cartItems[itemId]! - 1;
      } else {
        _cartItems.remove(itemId);
      }
      emit(MealCartUpdated(cartItems: Map.from(_cartItems), total: cartTotal));
    }
  }

  void clearCart() {
    _cartItems.clear();
    emit(MealCartUpdated(cartItems: Map.from(_cartItems), total: cartTotal));
  }

  Future<void> submitOrder() async {
    if (_cartItems.isEmpty) {
      emit(const MealError('السلة فارغة'));
      return;
    }

    emit(MealOrderSubmitting());

    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';
    final userName = user?.displayName?.isNotEmpty == true
        ? user!.displayName!
        : 'مستخدم';

    final order = MealOrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      userName: userName,
      items: cartOrderItems,
      total: cartTotal,
      isPaid: false,
      isBreakFast: await _isBreakFastUser(userId),
      date: DateTime.now(),
      createdAt: DateTime.now(),
    );

    final result = await _mealRepo.createOrder(order);
    result.fold((error) => emit(MealError(error)), (_) {
      _cartItems.clear();
      emit(MealOrderSubmitted(order));
    });
  }

  Future<bool> _isBreakFastUser(String userId) async {
    try {
      final doc = await _firestore
          .collection(FirestoreConstants.users)
          .doc(userId)
          .get();
      return doc.data()?[FirestoreConstants.isBreakFast] == true;
    } catch (_) {
      return true;
    }
  }

  Future<void> addMealItem(MealItemModel item) async {
    final result = await _mealRepo.addMealItem(item);
    result.fold((error) => emit(MealError(error)), (_) {
      emit(MealItemSaved());
      loadMenu();
    });
  }

  Future<void> updateMealItem(MealItemModel item) async {
    final result = await _mealRepo.updateMealItem(item);
    result.fold((error) => emit(MealError(error)), (_) {
      emit(MealItemSaved());
      loadMenu();
    });
  }

  Future<void> deleteMealItem(String itemId) async {
    final result = await _mealRepo.deleteMealItem(itemId);
    result.fold((error) => emit(MealError(error)), (_) {
      emit(MealItemDeleted());
      loadMenu();
    });
  }

  Future<void> toggleAvailability(String itemId) async {
    final index = _menuItems.indexWhere((e) => e.id == itemId);
    if (index == -1) return;

    final item = _menuItems[index];
    await updateMealItem(item.copyWith(isAvailable: !item.isAvailable));
  }

  Future<void> loadOrders(DateTime date) async {
    emit(MealLoading());
    final result = await _mealRepo.getOrders(date);
    result.fold((error) => emit(MealError(error)), (orders) {
      _orders = orders;
      emit(MealOrdersLoaded(orders));
    });
  }

  Future<void> updatePaymentStatus(String orderId, bool isPaid) async {
    final result = await _mealRepo.updatePaymentStatus(orderId, isPaid);
    result.fold(
      (error) => emit(MealError(error)),
      (_) => emit(MealPaymentUpdated()),
    );
  }
}
