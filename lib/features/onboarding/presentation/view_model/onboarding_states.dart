import 'package:equatable/equatable.dart';

abstract class OnboardingStates extends Equatable {
  const OnboardingStates();

  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingStates {
  const OnboardingInitial();
}

class OnboardingPageChanged extends OnboardingStates {
  final int currentPage;
  final int totalPages;

  const OnboardingPageChanged({
    required this.currentPage,
    required this.totalPages,
  });

  bool get isLastPage => currentPage == totalPages - 1;

  @override
  List<Object?> get props => [currentPage, totalPages];
}

class OnboardingCompleted extends OnboardingStates {
  const OnboardingCompleted();
}
