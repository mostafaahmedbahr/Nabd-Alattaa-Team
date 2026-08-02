import 'package:firebase_auth/firebase_auth.dart';
import 'package:nabd_alattaa_team/common_imports.dart';
import '../view_model/home_cubit.dart';
import '../widgets/welcome_section.dart';
import '../widgets/quick_actions_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<HomeCubit>().loadHomeData(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("الرئيسية"),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WelcomeSection(),
                SizedBox(height: 24.h),
              const QuickActionsGrid(),
                SizedBox(height: 24.h),

            ],
          ),
        ),
      ),
    );
  }
}
