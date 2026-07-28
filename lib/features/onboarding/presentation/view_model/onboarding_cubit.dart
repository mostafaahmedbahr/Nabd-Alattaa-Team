import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common_imports.dart';
import '../../data/models/onboarding_page_model.dart';
import 'onboarding_states.dart';

class OnboardingCubit extends Cubit<OnboardingStates> {
  final PageController pageController = PageController();
  int _currentPage = 0;

  static const int _totalPages = 3;

  OnboardingCubit() : super(const OnboardingInitial());

  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  void onPageChanged(int index) {
    _currentPage = index;
    emit(OnboardingPageChanged(
      currentPage: _currentPage,
      totalPages: _totalPages,
    ));
  }

  void onNext(BuildContext context) {
    if (_currentPage < _totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding(context);
    }
  }

  void onSkip(BuildContext context) {
    completeOnboarding(context);
  }

  Future<void> completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    emit(const OnboardingCompleted());
    if (context.mounted) {
      context.go('/login');
    }
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }

      List<OnboardingPageModel> pages = [
      OnboardingPageModel(
      icon: Icons.handshake_rounded,
      title: 'مرحباً بك',
      subtitle: 'في تطبيق نبض العطاء',
      description: 'منصة تجمع فريق العمل في مكان واحد\nلتتواصل وتتعاون وتنجز مهامك بسهولة',
    ),
      OnboardingPageModel(
      icon: Icons.task_alt_rounded,
      title: 'تنظيم مهامك',
      subtitle: 'بكل سهولة',
      description: 'تابع مهامك اليومية وأدر تقاريرك\nوأرسل شكاواك واستفساراتك في أي وقت',
    ),
      OnboardingPageModel(
      icon: Icons.people_rounded,
      title: 'تواصل مع فريقك',
      subtitle: 'واحصل على أفضل تجربة',
      description: 'ادردش مع زملائك وشارك أفكارك\nواحصل على آخر الأخبار والإعلانات',
    ),
  ];

}
