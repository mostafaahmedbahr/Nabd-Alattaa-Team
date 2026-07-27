import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/complaint_repo.dart';
import '../../data/models/complaint_model.dart';
import 'complaint_state.dart';

class ComplaintCubit extends Cubit<ComplaintState> {
  final ComplaintRepository complaintRepository;
  StreamSubscription? _subscription;

  ComplaintCubit({required this.complaintRepository}) : super(ComplaintInitial());

  void loadComplaints({String? status}) {
    emit(ComplaintLoading());
    _subscription?.cancel();
    _subscription = complaintRepository.getComplaints(status: status).listen(
      (complaints) => emit(ComplaintLoaded(complaints: complaints)),
      onError: (error) => emit(ComplaintError(message: error.toString())),
    );
  }

  Future<void> createComplaint(ComplaintModel complaint) async {
    final result = await complaintRepository.createComplaint(complaint);
    result.fold(
      (failure) => emit(ComplaintError(message: failure.message)),
      (_) => loadComplaints(),
    );
  }

  Future<void> updateStatus(String complaintId, String status) async {
    final result = await complaintRepository.updateComplaintStatus(complaintId, status);
    result.fold(
      (failure) => emit(ComplaintError(message: failure.message)),
      (_) {},
    );
  }

  @override
  void close() {
    _subscription?.cancel();
    return super.close();
  }
}
