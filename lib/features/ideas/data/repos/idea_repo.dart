import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/idea_model.dart';

abstract class IdeaRepository {
  Stream<List<IdeaModel>> getIdeas({String? status});
  Future<Either<Failure, void>> createIdea(IdeaModel idea);
  Future<Either<Failure, void>> updateIdeaStatus(String ideaId, String status, int rating);
}
