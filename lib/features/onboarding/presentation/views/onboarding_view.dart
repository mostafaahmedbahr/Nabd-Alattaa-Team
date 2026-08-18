import '../../../../common_imports.dart';
import '../view_model/onboarding_cubit.dart';
import '../view_model/onboarding_states.dart';
import '../widgets/onboarding_background.dart';
import '../widgets/onboarding_page.dart';
import '../widgets/onboarding_dots.dart';
import '../widgets/onboarding_button.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    return Scaffold(
      body: OnboardingBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.h, left: 10.w),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: TextButton(
                      onPressed: () => cubit.onSkip(context),
                      child: Text(
                        'تخطي',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14.sp,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: cubit.pageController,
                    itemCount: cubit.pages.length,
                    onPageChanged: cubit.onPageChanged,
                    itemBuilder: (context, index) =>
                        OnboardingPage(page: cubit.pages[index]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 50),
                  child: BlocBuilder<OnboardingCubit, OnboardingStates>(
                    builder: (context, state) {
                      final currentPage = state is OnboardingPageChanged
                          ? state.currentPage
                          : 0;
                      final isLastPage = state is OnboardingPageChanged
                          ? state.isLastPage
                          : false;

                      return Column(
                        children: [
                          OnboardingDots(
                            currentPage: currentPage,
                            totalPages: cubit.pages.length,
                          ),
                          SizedBox(height: 30.h),
                          OnboardingButton(
                            isLastPage: isLastPage,
                            onPressed: () => cubit.onNext(context),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
