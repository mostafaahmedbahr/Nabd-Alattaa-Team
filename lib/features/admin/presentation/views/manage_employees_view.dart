import '../../../../common_imports.dart';
import '../widgets/manage_employees_widgets/manage_employees_view_body.dart';

class ManageEmployeesView extends StatefulWidget {
  const ManageEmployeesView({super.key});

  @override
  State<ManageEmployeesView> createState() => _ManageEmployeesViewState();
}

class _ManageEmployeesViewState extends State<ManageEmployeesView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'إدارة الموظفين',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: AdaptiveContainer(
        child: ManageEmployeesViewBody(),
      ),
    );
  }

}
