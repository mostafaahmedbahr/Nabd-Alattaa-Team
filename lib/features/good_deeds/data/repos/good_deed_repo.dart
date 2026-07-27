import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/good_deed_model.dart';

abstract class GoodDeedRepository {
  Stream<Either<Failure, List<GoodDeedModel>>> getGoodDeeds();
  Future<Either<Failure, void>> addGoodDeed(GoodDeedModel deed);
  Future<Either<Failure, void>> likeDeed(String deedId, String userId);
  Future<Either<Failure, void>> prayForDeed(String deedId, String userId);
  Future<Either<Failure, bool>> hasUserLiked(String deedId, String userId);
  Future<Either<Failure, bool>> hasUserPrayed(String deedId, String userId);
}
