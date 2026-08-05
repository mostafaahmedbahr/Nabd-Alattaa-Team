import 'package:dartz/dartz.dart';

import '../models/meal_item_model.dart';
import '../models/meal_order_model.dart';

abstract class MealRepository {
  Future<Either<String, List<MealItemModel>>> getMenu();
  Future<Either<String, void>> addMealItem(MealItemModel item);
  Future<Either<String, void>> updateMealItem(MealItemModel item);
  Future<Either<String, void>> deleteMealItem(String itemId);
  Future<Either<String, void>> createOrder(MealOrderModel order);
  Future<Either<String, List<MealOrderModel>>> getOrders(DateTime date);
  Future<Either<String, void>> updatePaymentStatus(
      String orderId, bool isPaid);
}
