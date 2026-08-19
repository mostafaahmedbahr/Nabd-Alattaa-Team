import 'package:firebase_auth/firebase_auth.dart';
import '../../../../common_imports.dart';
import '../../../profile/presentation/view_model/profile_cubit.dart';
import '../../../profile/presentation/view_model/profile_state.dart';
import '../view_model/meal_cubit.dart';
import '../widgets/meal_orders_view_body.dart';

class MealOrdersView extends StatefulWidget {
  const MealOrdersView({super.key});

  @override
  State<MealOrdersView> createState() => _MealOrdersViewState();
}

class _MealOrdersViewState extends State<MealOrdersView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _checkAccess();
    });
    context.read<MealCubit>().loadOrders(DateTime.now());
  }

  Future<void> _checkAccess() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _kickOut();
      return;
    }

    final cubit = context.read<ProfileCubit>();
    if (cubit.state is! ProfileLoaded) {
      await cubit.loadProfile(user.uid);
    }

    if (!mounted) return;

    final state = cubit.state;
    if (state is ProfileLoaded && state.profile.isBreakFast) {
      return;
    }

    _kickOut();
  }

  void _kickOut() {
    if (!mounted) return;
    Navigator.of(context).maybePop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('غير مصرح لك بالوصول لهذه الصفحة'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('طلبات اليوم'),
          actions: [
            IconButton(
              onPressed: () =>
                  context.read<MealCubit>().loadOrders(DateTime.now()),
              icon: const Icon(Icons.refresh_rounded),
            ),
          ],
        ),
        body: const MealOrdersViewBody(),
      ),
    );
  }
}
