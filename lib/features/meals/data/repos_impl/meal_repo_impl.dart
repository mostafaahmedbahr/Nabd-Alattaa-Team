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
          .collection(FirestoreConstants.mealItemsCollection)
          .get();

      final items = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return MealItemModel.fromMap(data);
      }).toList();

      return Right(items);
    } catch (e) {
      return Left('فشل في تحميل القائمة: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> addMealItem(MealItemModel item) async {
    try {
      final docRef = _firestore
          .collection(FirestoreConstants.mealItemsCollection)
          .doc();

      await docRef.set({
        ...item.toMap(),
        'id': docRef.id,
      });

      return const Right(null);
    } catch (e) {
      return Left('فشل في إضافة الوجبة: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> updateMealItem(MealItemModel item) async {
    try {
      await _firestore
          .collection(FirestoreConstants.mealItemsCollection)
          .doc(item.id)
          .update(item.toMap());

      return const Right(null);
    } catch (e) {
      return Left('فشل في تعديل الوجبة: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> deleteMealItem(String itemId) async {
    try {
      await _firestore
          .collection(FirestoreConstants.mealItemsCollection)
          .doc(itemId)
          .delete();

      return const Right(null);
    } catch (e) {
      return Left('فشل في حذف الوجبة: ${e.toString()}');
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
