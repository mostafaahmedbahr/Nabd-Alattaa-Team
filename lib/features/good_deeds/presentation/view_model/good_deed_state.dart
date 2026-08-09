
import '../../data/models/good_deed_model.dart';

abstract class GoodDeedStates {}
class GoodDeedInitial extends GoodDeedStates {
}

class GoodDeedLoading extends GoodDeedStates {}

class GoodDeedLoaded extends GoodDeedStates {
  final List<GoodDeedModel> goodDeeds;
    GoodDeedLoaded({required this.goodDeeds});
}

class GoodDeedError extends GoodDeedStates {
  final String message;
    GoodDeedError({required this.message});
}

class GoodDeedAdded extends GoodDeedStates {}

class GoodDeedActionError extends GoodDeedStates {
  final String message;

    GoodDeedActionError({required this.message});


}

class GoodDeedAddLoading extends GoodDeedStates {}

class GoodDeedAddSuccess extends GoodDeedStates {
  final GoodDeedModel deed;

  GoodDeedAddSuccess({
    required this.deed,
  });
}

class GoodDeedAddError extends GoodDeedStates {
  final String message;

  GoodDeedAddError({
    required this.message,
  });
}
