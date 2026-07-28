import 'package:firebase_auth/firebase_auth.dart';
import '../../../../common_imports.dart';

void navigateToNext(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

  if (!onboardingComplete) {
    if (context.mounted) {
      context.go('/onboarding');
    }
    return;
  }

  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    if (context.mounted) {
      context.go('/');
    }
  } else {
    if (context.mounted) {
      context.go('/login');
    }
  }
}