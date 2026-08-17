import 'package:nabd_alattaa_team/common_imports.dart';
import '../../../../core/router/app_routes.dart';
import 'quick_action_card.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اجراءات سريعة',
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _buildAction(context, Icons.library_books_outlined, "المكتبة", Routes.library),
            _buildAction(context, Icons.volunteer_activism_outlined, "عملت خير", Routes.goodDeeds),
            _buildAction(context, Icons.restaurant_outlined, "طلبات الطعام", Routes.meals),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _buildAction(context, Icons.lightbulb_outline, "صندوق الأفكار", Routes.ideas),
            _buildAction(context, Icons.feedback_outlined, "الشكاوى", Routes.complaints),
          ],
        ),


      ],
    );
  }

  Widget _buildAction(BuildContext context, IconData icon, String label, String route) {
    return Expanded(
      child: Padding(
        padding:   EdgeInsets.symmetric(horizontal: 4.w),
        child: QuickActionCard(
          icon: icon,
          label: label,
          onTap: () => context.push(route),
        ),
      ),
    );
  }
}
