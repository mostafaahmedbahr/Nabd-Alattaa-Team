import 'package:equatable/equatable.dart';

import '../../data/models/complaint_model.dart';

abstract class ComplaintState extends Equatable {
  const ComplaintState();

  @override
  List<Object?> get props => [];
}

class ComplaintInitial extends ComplaintState {
  const ComplaintInitial();
}

class ComplaintLoading extends ComplaintState {
  const ComplaintLoading();
}

class ComplaintLoaded extends ComplaintState {
  final List<ComplaintModel> complaints;

  const ComplaintLoaded({required this.complaints});

  @override
  List<Object?> get props => [complaints];
}

class ComplaintError extends ComplaintState {
  final String message;

  const ComplaintError({required this.message});

  @override
  List<Object?> get props => [message];
}
