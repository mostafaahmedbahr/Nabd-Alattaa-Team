import 'package:equatable/equatable.dart';

import '../../data/models/good_deed_model.dart';

abstract class GoodDeedState extends Equatable {
  const GoodDeedState();

  @override
  List<Object?> get props => [];
}

class GoodDeedInitial extends GoodDeedState {
  const GoodDeedInitial();
}

class GoodDeedLoading extends GoodDeedState {
  const GoodDeedLoading();
}

class GoodDeedLoaded extends GoodDeedState {
  final List<GoodDeedModel> goodDeeds;

  const GoodDeedLoaded({required this.goodDeeds});

  @override
  List<Object?> get props => [goodDeeds];
}

class GoodDeedError extends GoodDeedState {
  final String message;

  const GoodDeedError({required this.message});

  @override
  List<Object?> get props => [message];
}

class GoodDeedAdded extends GoodDeedState {
  const GoodDeedAdded();
}

class GoodDeedActionError extends GoodDeedState {
  final String message;

  const GoodDeedActionError({required this.message});

  @override
  List<Object?> get props => [message];
}
