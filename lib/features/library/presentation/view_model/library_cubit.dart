import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  void close() {
    _subscription?.cancel();
    return super.close();
  }
}
