import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view_model/layout_cubit.dart';
import '../view_model/layout_states.dart';

class LayoutView extends StatelessWidget {
  const LayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCubit, LayoutStates>(
      builder: (context, state) {
        final cubit = context.read<LayoutCubit>();
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) => cubit.onPopInvoked(didPop, context),
          child: Scaffold(
            body: cubit.screens[LayoutCubit.pageIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: LayoutCubit.pageIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                cubit.changeBottomNav(index);
              },
              items: List.generate(
                cubit.titles.length,
                (index) => BottomNavigationBarItem(
                  icon: Icon(
                    LayoutCubit.pageIndex == index
                        ? cubit.selectedIcons[index]
                        : cubit.icons[index],
                  ),
                  label: cubit.titles[index],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
