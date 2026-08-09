import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../../../common_imports.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../../data/models/complaint_model.dart';
import '../../data/repos/complaint_repo.dart';
import 'complaint_state.dart';

class ComplaintCubit extends Cubit<ComplaintState> {
  final ComplaintRepository _repository;
  StreamSubscription? _subscription;

  ComplaintCubit({required ComplaintRepository repository})
      : _repository = repository,
        super(const ComplaintInitial());

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  String selectedType = ComplaintType.other;
  bool isAnonymous = false;
  String selectedFilter = 'all';

  void loadComplaints({String? status}) {
    _subscription?.cancel();
    emit(const ComplaintLoading());

    _subscription = _repository.getComplaints(status: status).listen(
          (result) {
            result.fold(
              (failure) => emit(ComplaintError(message: failure.message)),
              (complaints) => emit(ComplaintLoaded(complaints: complaints)),
            );
          },
          onError: (error) {
            emit(ComplaintError(message: 'حدث خطأ غير متوقع'));
          },
        );
  }

  void refresh() {
    loadComplaints(status: selectedFilter == 'all' ? null : selectedFilter);
  }

  void changeFilter(String filter) {
    if (selectedFilter == filter) return;
    selectedFilter = filter;
    loadComplaints(status: filter == 'all' ? null : filter);
  }

  Future<void> createComplaint({
    required String title,
    required String content,
    required String creatorId,
    required String creatorName,
  }) async {
    emit(const ComplaintAddLoading());

    try {
      final complaint = ComplaintModel(
        id: const Uuid().v4(),
        title: title,
        content: content,
        type: selectedType,
        isAnonymous: isAnonymous,
        creatorId: creatorId,
        creatorName: isAnonymous ? 'مجهول' : creatorName,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = await _repository.createComplaint(complaint);

      result.fold(
        (failure) => emit(ComplaintAddError(message: failure.message)),
        (_) {
          clearForm();
          emit(ComplaintAddSuccess(complaint: complaint));
        },
      );
    } catch (e) {
      emit(ComplaintAddError(message: e.toString()));
    }
  }

  void clearForm() {
    titleController.clear();
    contentController.clear();
    selectedType = ComplaintType.other;
    isAnonymous = false;
    selectedFilter = 'all';
  }

  Future<void> updateStatus(String complaintId, String status) async {
    final result = await _repository.updateComplaintStatus(complaintId, status);
    result.fold(
      (failure) => emit(ComplaintActionError(message: failure.message)),
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
