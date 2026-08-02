import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/library_item_model.dart';

abstract class LibraryRepository {
  Stream<List<LibraryItemModel>> getItems();
  Stream<List<LibraryItemModel>> getItemsByCategory(String category);
  Future<Either<Failure, void>> addItem(LibraryItemModel item);
}
