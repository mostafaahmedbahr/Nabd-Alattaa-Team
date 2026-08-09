import 'dart:async';
import 'package:uuid/uuid.dart';
import '../../../../common_imports.dart';
import '../../data/models/good_deed_model.dart';
import '../../data/repos/good_deed_repo.dart';
import 'good_deed_state.dart';

class GoodDeedCubit extends Cubit<GoodDeedStates> {
  final GoodDeedRepository _repository;
  StreamSubscription? _subscription;

  GoodDeedCubit({required GoodDeedRepository repository})
      : _repository = repository,
        super(  GoodDeedInitial());

  void loadGoodDeeds() {
    _subscription?.cancel();
    emit(  GoodDeedLoading());

    _subscription = _repository.getGoodDeeds().listen(
      (result) {
        result.fold(
          (failure) => emit(GoodDeedError(message: failure.message)),
          (deeds) => emit(GoodDeedLoaded(goodDeeds: deeds)),
        );
      },
      onError: (error) {
        emit(GoodDeedError(message: 'حدث خطأ غير متوقع'));
      },
    );
  }


  Future<void> addGoodDeed({
    required String title,
    required String content,
    required String creatorId,
  }) async {
    emit(GoodDeedAddLoading());

    try {
      final deed = GoodDeedModel(
        id: const Uuid().v4(),
        title: title,
        content: content,
        creatorId: creatorId,
        createdAt: DateTime.now(),
      );

      final result = await _repository.addGoodDeed(deed);

      result.fold(
            (failure) {
          emit(
            GoodDeedAddError(
              message: failure.message,
            ),
          );
        },
            (_) {
          emit(
            GoodDeedAddSuccess(
              deed: deed,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        GoodDeedAddError(
          message: e.toString(),
        ),
      );
    }
  }



  Future<void> likeDeed(String deedId, String userId) async {
    final result = await _repository.likeDeed(deedId, userId);
    result.fold(
      (failure) => emit(GoodDeedActionError(message: failure.message)),
      (_) {},
    );
  }

  Future<void> prayForDeed(String deedId, String userId) async {
    final result = await _repository.prayForDeed(deedId, userId);
    result.fold(
      (failure) => emit(GoodDeedActionError(message: failure.message)),
      (_) {},
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    titleController.dispose();
    descriptionController.dispose();
    return super.close();
  }


  /// create good deed
  final  titleController = TextEditingController();
  final  descriptionController = TextEditingController();
  final  formKey = GlobalKey<FormState>();





}
