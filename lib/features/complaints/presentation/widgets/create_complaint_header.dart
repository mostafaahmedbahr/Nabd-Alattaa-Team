import '../../../../common_imports.dart';

class CreateComplaintHeader extends StatelessWidget {
  const CreateComplaintHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primary,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'شكوى جديدة',
          style: TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                AppColors.complaintsGradientStart,
                AppColors.primary,
                AppColors.complaintsGradientEnd,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ),
              const Positioned(
                top: 60,
                left: 24,
                child: Icon(
                  Icons.feedback_outlined,
                  size: 80,
                  color: Colors.white12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
