import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../data/repos/library_repo.dart';
import '../../data/models/library_item_model.dart';
import 'library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  final LibraryRepository libraryRepository;
  StreamSubscription? _subscription;

  LibraryCubit({required this.libraryRepository}) : super(LibraryInitial());

  void loadItems() {
    emit(LibraryLoading());
    _subscription?.cancel();
    _subscription = libraryRepository.getItems().listen(
      (items) => emit(LibraryLoaded(items: items)),
      onError: (error) => emit(LibraryError(message: error.toString())),
    );
  }

  void loadItemsByCategory(String category) {
    emit(LibraryLoading());
    _subscription?.cancel();
    _subscription = libraryRepository.getItemsByCategory(category).listen(
      (items) => emit(LibraryLoaded(items: items)),
      onError: (error) => emit(LibraryError(message: error.toString())),
    );
  }

  Future<void> addItem({
    required String name,
    required String description,
    required String category,
    required String fileUrl,
  }) async {
    final item = LibraryItemModel(
      id: const Uuid().v4(),
      name: name,
      description: description,
      category: category,
      fileUrl: fileUrl,
      createdAt: DateTime.now(),
    );

    final result = await libraryRepository.addItem(item);
    result.fold(
      (failure) => emit(LibraryActionError(message: failure.message)),
      (_) {},
    );
  }

  // @override
  // void close() {
  //   _subscription?.cancel();
  //   return super.close();
  // }
}
