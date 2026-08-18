import '../../../../../common_imports.dart';
import '../../view_model/admin_cubit.dart';
import '../../view_model/admin_state.dart';
import 'dashboard_content.dart';

class AdminDashboardViewBody extends StatelessWidget {
  const AdminDashboardViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        if (state is AdminLoading) {
          return const LoadingWidget(message: AppStrings.loading);
        }

        if (state is AdminError) {
          return CustomErrorWidget(
            message: state.message,
            onRetry: () => context.read<AdminCubit>().loadDashboard(),
          );
        }

        if (state is DashboardLoaded) {
          return DashboardContent(state:state);
        }

        return const SizedBox.shrink();
      },
    );
  }
}
