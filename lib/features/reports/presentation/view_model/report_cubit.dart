import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/report_repo.dart';
import '../../data/models/report_model.dart';
import 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportRepository reportRepository;
  StreamSubscription? _subscription;

  ReportCubit({required this.reportRepository}) : super(ReportInitial());

  void loadReports({String? status}) {
    emit(ReportLoading());
    _subscription?.cancel();
    _subscription = reportRepository.getReports(status: status).listen(
      (reports) => emit(ReportLoaded(reports: reports)),
      onError: (error) => emit(ReportError(message: error.toString())),
    );
  }

  Future<void> createReport(ReportModel report) async {
    final result = await reportRepository.createReport(report);
    result.fold(
      (failure) => emit(ReportError(message: failure.message)),
      (_) => loadReports(),
    );
  }

  Future<void> updateStatus(String reportId, String status) async {
    final result = await reportRepository.updateReportStatus(reportId, status);
    result.fold(
      (failure) => emit(ReportError(message: failure.message)),
      (_) {},
    );
  }

  @override
  void close() {
    _subscription?.cancel();
    return super.close();
  }
}
