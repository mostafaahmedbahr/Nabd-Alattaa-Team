import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Map<String, dynamic>> _quickActionsRow1 = [
    {'icon': Icons.task_alt, 'label': 'المهام'},
    {'icon': Icons.campaign, 'label': 'الإعلانات'},
    {'icon': Icons.report_outlined, 'label': 'البلاغات'},
    {'icon': Icons.feedback_outlined, 'label': 'الشكاوى'},
  ];

  static const List<Map<String, dynamic>> _quickActionsRow2 = [
    {'icon': Icons.lightbulb_outline, 'label': 'صندوق الأفكار'},
    {'icon': Icons.library_books_outlined, 'label': 'المكتبة'},
    {'icon': Icons.volunteer_activism_outlined, 'label': 'عملت خير'},
    {'icon': Icons.restaurant_outlined, 'label': 'طلبات الطعام'},
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 24),
            _buildQuickActions(context),
            const SizedBox(height: 24),
            _buildSectionTitle('آخر الإعلانات'),
            const SizedBox(height: 8),
            _buildRecentAnnouncements(),
            const SizedBox(height: 24),
            _buildSectionTitle('آخر المهام'),
            const SizedBox(height: 8),
            _buildRecentTasks(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              'assets/images/logo.jpg',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً بك،',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'أحمد محمد',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'نتمنى لك يوماً موفقاً',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        _buildActionsRow(_quickActionsRow1),
        const SizedBox(height: 12),
        _buildActionsRow(_quickActionsRow2),
      ],
    );
  }

  Widget _buildActionsRow(List<Map<String, dynamic>> actions) {
    return Row(
      children: actions.map((action) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _buildActionCard(
              icon: action['icon'] as IconData,
              label: action['label'] as String,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionCard({required IconData icon, required String label}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: AppColors.primary,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'عرض الكل',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentAnnouncements() {
    return Column(
      children: List.generate(3, (index) {
        return _buildAnnouncementCard(
          title: 'إعلان ${(index + 1)}',
          subtitle: 'هذا نص تجريبي للإعلان رقم ${index + 1}',
          time: '${index + 1} ساعات مضت',
        );
      }),
    );
  }

  Widget _buildAnnouncementCard({
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.campaign_outlined,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: AppTextStyles.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Text(
          time,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTasks() {
    return Column(
      children: List.generate(3, (index) {
        return _buildTaskCard(
          title: 'مهمة ${(index + 1)}',
          subtitle: 'وصف المهمة رقم ${index + 1}',
          status: index == 0 ? 'مكتملة' : (index == 1 ? 'قيد التنفيذ' : 'جديدة'),
          statusColor: index == 0
              ? Colors.green
              : (index == 1 ? Colors.orange : Colors.blue),
        );
      }),
    );
  }

  Widget _buildTaskCard({
    required String title,
    required String subtitle,
    required String status,
    required Color statusColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.task_alt_outlined,
            color: statusColor,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: AppTextStyles.bodySmall,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: AppTextStyles.bodySmall.copyWith(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
