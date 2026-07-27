import 'package:equatable/equatable.dart';

import '../../data/models/idea_model.dart';

abstract class IdeaState extends Equatable {
  const IdeaState();

  @override
  List<Object?> get props => [];
}

class IdeaInitial extends IdeaState {
  const IdeaInitial();
}

class IdeaLoading extends IdeaState {
  const IdeaLoading();
}

class IdeaLoaded extends IdeaState {
  final List<IdeaModel> ideas;

  const IdeaLoaded({required this.ideas});

  @override
  List<Object?> get props => [ideas];
}

class IdeaError extends IdeaState {
  final String message;

  const IdeaError({required this.message});

  @override
  List<Object?> get props => [message];
}
