import 'package:nabd_alattaa_team/common_imports.dart';
import '../../../notifications/presentation/view_model/notification_cubit.dart';
import '../view_model/home_cubit.dart';
import '../view_model/home_states.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_view_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    final state = context.read<HomeCubit>().state;
    if (state is! HomeLoaded) {
      context.read<HomeCubit>().loadData();
    }
    context.read<NotificationCubit>().loadNotificationsData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: HomeViewBody(),
    );
  }
}
