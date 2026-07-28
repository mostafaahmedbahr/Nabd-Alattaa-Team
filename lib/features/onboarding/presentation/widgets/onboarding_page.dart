import '../../../../common_imports.dart';
import '../../data/models/onboarding_page_model.dart';
import 'onboarding_icon_widget.dart';
import 'onboarding_text_widget.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key, required this.page});
  final OnboardingPageModel page;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:   EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OnboardingIconWidget(icon: page.icon),
          SizedBox(height: 50.h),
          OnboardingTextWidget(
            title: page.title,
            subtitle: page.subtitle,
            description: page.description,
          ),
        ],
      ),
    );
  }
}
