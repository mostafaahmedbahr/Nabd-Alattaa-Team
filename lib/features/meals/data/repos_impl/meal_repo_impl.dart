import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../models/meal_item_model.dart';
import '../models/meal_order_model.dart';
import '../repos/meal_repo.dart';

class MealRepoImpl implements MealRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<String, List<MealItemModel>>> getMenu() async {
    try {
      final snapshot = await _firestore
          .collection(FirestoreConstants.mealsCollection)
          .get();

      final items = snapshot.docs
          .map((doc) => MealItemModel.fromMap(doc.data()))
          .toList();

      return Right(items);
    } catch (e) {
      return Left('فشل في تحميل القائمة: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> createOrder(MealOrderModel order) async {
    try {
      await _firestore
          .collection(FirestoreConstants.mealOrdersCollection)
          .doc(order.id)
          .set(order.toMap());

      return const Right(null);
    } catch (e) {
      return Left('فشل في إنشاء الطلب: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<MealOrderModel>>> getOrders(
      DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay =
          DateTime(date.year, date.month, date.day, 23, 59, 59);

      final snapshot = await _firestore
          .collection(FirestoreConstants.mealOrdersCollection)
          .where('date',
              isGreaterThanOrEqualTo: startOfDay.millisecondsSinceEpoch)
          .where('date',
              isLessThanOrEqualTo: endOfDay.millisecondsSinceEpoch)
          .orderBy('date', descending: true)
          .get();

      final orders = snapshot.docs
          .map((doc) => MealOrderModel.fromMap(doc.data()))
          .toList();

      return Right(orders);
    } catch (e) {
      return Left('فشل في تحميل الطلبات: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> updatePaymentStatus(
      String orderId, bool isPaid) async {
    try {
      await _firestore
          .collection(FirestoreConstants.mealOrdersCollection)
          .doc(orderId)
          .update({'isPaid': isPaid});

      return const Right(null);
    } catch (e) {
      return Left('فشل في تحديث حالة الدفع: ${e.toString()}');
    }
  }
}
