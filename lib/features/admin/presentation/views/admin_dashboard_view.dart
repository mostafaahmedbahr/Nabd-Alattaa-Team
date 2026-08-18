import '../../../../common_imports.dart';
import '../view_model/admin_cubit.dart';
import '../widgets/admin_dashboard_widgets/admin_dashboard_custom_app_bar.dart';
import '../widgets/admin_dashboard_widgets/admin_dashboard_view_body.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AdminDashboardCustomAppBar(),
      body: AdminDashboardViewBody(),
    );
  }






}
