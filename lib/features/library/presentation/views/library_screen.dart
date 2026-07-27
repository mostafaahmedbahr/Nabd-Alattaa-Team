import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../view_model/library_cubit.dart';
import '../view_model/library_state.dart';
import '../widgets/library_item_card.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.library)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip(context, 'الكل', ''),
                  const SizedBox(width: 8),
                  _buildCategoryChip(context, 'اللوجو', 'logo'),
                  const SizedBox(width: 8),
                  _buildCategoryChip(context, 'العقود', 'contracts'),
                  const SizedBox(width: 8),
                  _buildCategoryChip(context, 'السياسات', 'policies'),
                  const SizedBox(width: 8),
                  _buildCategoryChip(context, 'Word', 'word'),
                  const SizedBox(width: 8),
                  _buildCategoryChip(context, 'Excel', 'excel'),
                  const SizedBox(width: 8),
                  _buildCategoryChip(context, 'PDF', 'pdf'),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<LibraryCubit, LibraryState>(
              builder: (context, state) {
                if (state is LibraryLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is LibraryError) {
                  return Center(child: Text(state.message));
                }
                if (state is LibraryLoaded) {
                  if (state.items.isEmpty) {
                    return const Center(child: Text(AppStrings.noData));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      return LibraryItemCard(
                        item: state.items[index],
                        onTap: () async {
                          final url = Uri.parse(state.items[index].fileUrl);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, String label, String category) {
    return FilterChip(
      label: Text(label),
      onSelected: (selected) {
        if (selected) {
          if (category.isEmpty) {
            context.read<LibraryCubit>().loadItems();
          } else {
            context.read<LibraryCubit>().loadItemsByCategory(category);
          }
        }
      },
    );
  }
}
