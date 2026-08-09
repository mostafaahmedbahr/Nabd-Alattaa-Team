import 'package:equatable/equatable.dart';

import '../../data/models/report_model.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {
  const ReportInitial();
}

class ReportLoading extends ReportState {
  const ReportLoading();
}

class ReportLoaded extends ReportState {
  final List<ReportModel> reports;

  const ReportLoaded({required this.reports});

  @override
  List<Object?> get props => [reports];
}

class ReportError extends ReportState {
  final String message;

  const ReportError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ReportAddLoading extends ReportState {
  const ReportAddLoading();
}

class ReportAddSuccess extends ReportState {
  final ReportModel report;

  const ReportAddSuccess({required this.report});

  @override
  List<Object?> get props => [report];
}

class ReportAddError extends ReportState {
  final String message;

  const ReportAddError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ReportActionError extends ReportState {
  final String message;

  const ReportActionError({required this.message});

  @override
  List<Object?> get props => [message];
}
