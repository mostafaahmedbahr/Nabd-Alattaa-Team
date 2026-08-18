import '../../../../common_imports.dart';
import '../view_model/layout_cubit.dart';
import '../view_model/layout_states.dart';

class LayoutView extends StatelessWidget {
  const LayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCubit, LayoutStates>(
      builder: (context, state) {
        final cubit = context.read<LayoutCubit>();
        final isWide = context.isWideScreen;
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) => cubit.onPopInvoked(didPop, context),
          child: Scaffold(
body: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isWide) buildNavigationRail(context, cubit),
                Expanded(
                  child: isWide
                      ? AdaptiveContainer(
                          maxWidth: 980,
                          child: cubit.screens[LayoutCubit.pageIndex],
                        )
                      : cubit.screens[LayoutCubit.pageIndex],
                ),
              ],
            ),
            bottomNavigationBar: isWide
                ? null
                : BottomNavigationBar(
                    currentIndex: LayoutCubit.pageIndex,
                    type: BottomNavigationBarType.fixed,
                    onTap: cubit.changeBottomNav,
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

  Widget buildNavigationRail(BuildContext context, LayoutCubit cubit) {
    return NavigationRail(
      selectedIndex: LayoutCubit.pageIndex,
      onDestinationSelected: cubit.changeBottomNav,
      labelType: context.isDesktop
          ? NavigationRailLabelType.all
          : NavigationRailLabelType.selected,
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.primary.withValues(alpha: 0.12),
      selectedIconTheme: const IconThemeData(color: AppColors.primary),
      selectedLabelTextStyle: const TextStyle(
        fontFamily: 'Cairo',
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
      unselectedLabelTextStyle: const TextStyle(
        fontFamily: 'Cairo',
        color: AppColors.grey500,
      ),
      destinations: List.generate(
        cubit.titles.length,
        (index) => NavigationRailDestination(
          icon: Icon(cubit.icons[index]),
          selectedIcon: Icon(cubit.selectedIcons[index]),
          label: Text(cubit.titles[index]),
        ),
      ),
    );
  }
}