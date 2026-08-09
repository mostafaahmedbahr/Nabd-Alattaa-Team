import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../../../common_imports.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../../data/models/report_model.dart';
import '../../data/repos/report_repo.dart';
import 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportRepository _repository;
  StreamSubscription? _subscription;

  ReportCubit({required ReportRepository repository})
      : _repository = repository,
        super(const ReportInitial());

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  String selectedType = ReportType.other;
  String selectedFilter = 'all';

  void loadReports({String? status}) {
    _subscription?.cancel();
    emit(const ReportLoading());

    _subscription = _repository.getReports(status: status).listen(
          (result) {
            result.fold(
              (failure) => emit(ReportError(message: failure.message)),
              (reports) => emit(ReportLoaded(reports: reports)),
            );
          },
          onError: (error) {
            emit(ReportError(message: 'حدث خطأ غير متوقع'));
          },
        );
  }

  void refresh() {
    loadReports(status: selectedFilter == 'all' ? null : selectedFilter);
  }

  void changeFilter(String filter) {
    if (selectedFilter == filter) return;
    selectedFilter = filter;
    loadReports(status: filter == 'all' ? null : filter);
  }

  Future<void> createReport({
    required String title,
    required String content,
    required String creatorId,
    required String creatorName,
  }) async {
    emit(const ReportAddLoading());

    try {
      final report = ReportModel(
        id: const Uuid().v4(),
        title: title,
        content: content,
        type: selectedType,
        creatorId: creatorId,
        creatorName: creatorName,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = await _repository.createReport(report);

      result.fold(
        (failure) => emit(ReportAddError(message: failure.message)),
        (_) {
          clearForm();
          emit(ReportAddSuccess(report: report));
        },
      );
    } catch (e) {
      emit(ReportAddError(message: e.toString()));
    }
  }

  void clearForm() {
    titleController.clear();
    contentController.clear();
    selectedType = ReportType.other;
    selectedFilter = 'all';
  }

  Future<void> updateStatus(String reportId, String status) async {
    final result = await _repository.updateReportStatus(reportId, status);
    result.fold(
      (failure) => emit(ReportActionError(message: failure.message)),
      (_) {},
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    titleController.dispose();
    contentController.dispose();
    return super.close();
  }
}
