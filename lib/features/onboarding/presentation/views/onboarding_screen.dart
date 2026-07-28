import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      icon: Icons.handshake_rounded,
      title: 'مرحباً بك',
      subtitle: 'في تطبيق نبض العطاء',
      description: 'منصة تجمع فريق العمل في مكان واحد\nلتتواصل وتتعاون وتنجز مهامك بسهولة',
      color: AppColors.primary,
    ),
    _OnboardingPage(
      icon: Icons.task_alt_rounded,
      title: 'تنظيم مهامك',
      subtitle: 'بكل سهولة',
      description: 'تابع مهامك اليومية وأدر تقاريرك\nوأرسل شكاواك واستفساراتك في أي وقت',
      color: Color(0xFF5B2C82),
    ),
    _OnboardingPage(
      icon: Icons.people_rounded,
      title: 'تواصل مع فريقك',
      subtitle: 'واحصل على أفضل تجربة',
      description: 'ادردش مع زملائك وشارك أفكارك\nواحصل على آخر الأخبار والإعلانات',
      color: AppColors.secondaryDark,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _onSkip() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryDark,
              AppColors.primary,
              Color(0xFF7B4CA2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: _onSkip,
                  child: Text(
                    'تخطي',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ),

              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index], size);
                  },
                ),
              ),

              // Dots & Button
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 50),
                child: Column(
                  children: [
                    // Dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Next / Start button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentPage == _pages.length - 1
                                  ? 'ابدأ الآن'
                                  : 'التالي',
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _currentPage == _pages.length - 1
                                  ? Icons.rocket_launch_rounded
                                  : Icons.arrow_back_ios_new_rounded,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page, Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with circles
          SizedBox(
            width: size.width * 0.5,
            height: size.width * 0.5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer circle
                Container(
                  width: size.width * 0.5,
                  height: size.width * 0.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 2,
                    ),
                  ),
                ),
                // Middle circle
                Container(
                  width: size.width * 0.38,
                  height: size.width * 0.38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                // Inner circle with icon
                Container(
                  width: size.width * 0.28,
                  height: size.width * 0.28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    page.icon,
                    size: size.width * 0.12,
                    color: page.color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),

          // Subtitle
          Text(
            page.subtitle,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),

          // Title
          Text(
            page.title,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // Description
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              height: 1.8,
              color: Colors.white.withOpacity(0.75),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final Color color;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
  });
}
