import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/error/failures.dart';
import '../repos/library_repo.dart';
import '../models/library_item_model.dart';

class LibraryRepoImpl implements LibraryRepository {
  final FirebaseFirestore firestore;

  LibraryRepoImpl({required this.firestore});

  @override
  Stream<List<LibraryItemModel>> getItems() {
    return firestore
        .collection('library')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => LibraryItemModel.fromMap(doc.data()))
              .toList(),
        );
  }

  @override
  Stream<List<LibraryItemModel>> getItemsByCategory(String category) {
    return firestore
        .collection('library')
        .where('category', isEqualTo: category)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => LibraryItemModel.fromMap(doc.data()))
              .toList(),
        );
  }

  @override
  Future<Either<Failure, void>> addItem(LibraryItemModel item) async {
    try {
      final docRef = await firestore
          .collection('library')
          .add(item.toMap()..remove('id'));

      await docRef.update({'id': docRef.id});

      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(
        message: 'فشل في إضافة الرابط: ${e.toString()}',
      ));
    }
  }
}
