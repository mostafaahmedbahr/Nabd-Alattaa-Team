import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
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
            appBar: AppBar(
              centerTitle: true,
              title: Text(cubit.titles[LayoutCubit.pageIndex]),
            ),
            body: cubit.screens[LayoutCubit.pageIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: LayoutCubit.pageIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                cubit.changeBottomNav(index, context);

                switch (index) {
                  case 0:
                    context.go(Routes.home);
                    break;
                  case 1:
                    context.go(Routes.tasks);
                    break;
                  case 2:
                    context.go(Routes.notifications);
                    break;
                  case 3:
                    context.go(Routes.chat);
                    break;
                  case 4:
                    context.go(Routes.profile);
                    break;
                }
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