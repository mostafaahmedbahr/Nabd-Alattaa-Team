import 'package:equatable/equatable.dart';

class LibraryItemModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final String fileUrl;
  final DateTime createdAt;

  const LibraryItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.fileUrl,
    required this.createdAt,
  });

  factory LibraryItemModel.fromMap(Map<String, dynamic> map) {
    return LibraryItemModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      fileUrl: map['file_url'] ?? '',
      createdAt: map['created_at']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'file_url': fileUrl,
      'created_at': createdAt,
    };
  }

  @override
  List<Object?> get props => [id, name, description, category, fileUrl, createdAt];
}
