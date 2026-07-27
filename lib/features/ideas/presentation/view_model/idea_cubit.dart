import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/idea_repo.dart';
import '../../data/models/idea_model.dart';
import 'idea_state.dart';

class IdeaCubit extends Cubit<IdeaState> {
  final IdeaRepository ideaRepository;
  StreamSubscription? _subscription;

  IdeaCubit({required this.ideaRepository}) : super(IdeaInitial());

  void loadIdeas({String? status}) {
    emit(IdeaLoading());
    _subscription?.cancel();
    _subscription = ideaRepository.getIdeas(status: status).listen(
      (ideas) => emit(IdeaLoaded(ideas: ideas)),
      onError: (error) => emit(IdeaError(message: error.toString())),
    );
  }

  Future<void> createIdea(IdeaModel idea) async {
    final result = await ideaRepository.createIdea(idea);
    result.fold(
      (failure) => emit(IdeaError(message: failure.message)),
      (_) => loadIdeas(),
    );
  }

  Future<void> updateIdeaStatus(String ideaId, String status, int rating) async {
    final result = await ideaRepository.updateIdeaStatus(ideaId, status, rating);
    result.fold(
      (failure) => emit(IdeaError(message: failure.message)),
      (_) {},
    );
  }

  @override
  void close() {
    _subscription?.cancel();
    return super.close();
  }
}
