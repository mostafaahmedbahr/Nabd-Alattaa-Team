import 'package:equatable/equatable.dart';

import '../../data/models/library_item_model.dart';

abstract class LibraryState extends Equatable {
  const LibraryState();

  @override
  List<Object?> get props => [];
}

class LibraryInitial extends LibraryState {
  const LibraryInitial();
}

class LibraryLoading extends LibraryState {
  const LibraryLoading();
}

class LibraryLoaded extends LibraryState {
  final List<LibraryItemModel> items;

  const LibraryLoaded({required this.items});

  @override
  List<Object?> get props => [items];
}

class LibraryError extends LibraryState {
  final String message;

  const LibraryError({required this.message});

  @override
  List<Object?> get props => [message];
}

class LibraryActionError extends LibraryState {
  final String message;

  const LibraryActionError({required this.message});

  @override
  List<Object?> get props => [message];
}
