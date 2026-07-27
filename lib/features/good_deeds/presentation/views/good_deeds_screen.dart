import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../view_model/good_deed_cubit.dart';
import '../view_model/good_deed_state.dart';
import '../widgets/good_deed_card.dart';

class GoodDeedsScreen extends StatelessWidget {
  const GoodDeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const CustomAppBar(title: AppStrings.goodDeeds),
        body: BlocBuilder<GoodDeedCubit, GoodDeedState>(
          builder: (context, state) {
            if (state is GoodDeedLoading) {
              return const LoadingWidget(message: AppStrings.loading);
            }

            if (state is GoodDeedError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () {
                  context.read<GoodDeedCubit>().loadGoodDeeds();
                },
              );
            }

            if (state is GoodDeedLoaded) {
              if (state.goodDeeds.isEmpty) {
                return const EmptyStateWidget(
                  message: 'لا توجد أعمال خير بعد',
                  icon: Icons.favorite_border,
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<GoodDeedCubit>().loadGoodDeeds();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: state.goodDeeds.length,
                  itemBuilder: (context, index) {
                    final deed = state.goodDeeds[index];
                    return GoodDeedCard(
                      deed: deed,
                      isLiked: false,
                      isPrayed: false,
                      onLike: () {
                        context.read<GoodDeedCubit>().likeDeed(
                              deed.id,
                              'current_user_id',
                            );
                      },
                      onPray: () {
                        context.read<GoodDeedCubit>().prayForDeed(
                              deed.id,
                              'current_user_id',
                            );
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push('/good-deeds/create');
          },
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: AppColors.textWhite),
        ),
      ),
    );
  }
}
