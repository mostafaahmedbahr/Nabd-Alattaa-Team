import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/home_data_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeData>> getHomeData(String userId);
  Stream<int> getGoodDeedsCount(String userId);
  Stream<int> getComplaintsCount(String userId);
  Stream<int> getIdeasCount(String userId);
}
