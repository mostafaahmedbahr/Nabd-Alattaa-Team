import 'package:nabd_alattaa_team/common_imports.dart';
import '../../../../core/router/app_routes.dart';
import 'quick_action_card.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildAction(
              context,
              icon: Icons.task_alt,
              label: "المهام",
              route: Routes.tasks,
            ),
            _buildAction(
              context,
              icon: Icons.campaign,
              label: "الإعلانات",
              route: Routes.notifications,
            ),
            _buildAction(
              context,
              icon: Icons.report_outlined,
              label: "البلاغات",
              route: Routes.complaints,
            ),
            _buildAction(
              context,
              icon: Icons.feedback_outlined,
              label: "الشكاوى",
              route: Routes.complaints,
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _buildAction(
              context,
              icon: Icons.lightbulb_outline,
              label: "صندوق الأفكار",
              route: Routes.ideas,
            ),
            _buildAction(
              context,
              icon: Icons.library_books_outlined,
              label: "المكتبة",
              route: Routes.library,
            ),
            _buildAction(
              context,
              icon: Icons.volunteer_activism_outlined,
              label: "عملت خير",
              route: Routes.goodDeeds,
            ),
            _buildAction(
              context,
              icon: Icons.restaurant_outlined,
              label: "طلبات الطعام",
              route: Routes.meals,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: QuickActionCard(
          icon: icon,
          label: label,
          onTap: () => context.push(route),
        ),
      ),
    );
  }
}
