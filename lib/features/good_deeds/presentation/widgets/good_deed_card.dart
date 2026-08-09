import '../../../../common_imports.dart';
import '../../data/models/good_deed_model.dart';
import 'good_deed_avatar.dart';
import 'good_deed_content_text.dart';
import 'good_deed_footer.dart';

class GoodDeedCard extends StatefulWidget {
  final GoodDeedModel deed;
  final VoidCallback onLike;
  final VoidCallback? onTap;
  final bool isLiked;
  final int index;

  const GoodDeedCard({
    super.key,
    required this.deed,
    required this.onLike,
    this.onTap,
    this.isLiked = false,
    this.index = 0,
  });

  @override
  State<GoodDeedCard> createState() => _GoodDeedCardState();
}

class _GoodDeedCardState extends State<GoodDeedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartController;
  late Animation<double> heartScale;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    heartScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _heartController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500 + (widget.index * 80)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin:   EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: AppColors.grey100,
            width: 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: 0.08),
              blurRadius: 20.r,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(24.r),
            onTap: widget.onTap,
            splashColor: AppColors.secondary.withValues(alpha: 0.05),
            highlightColor: AppColors.secondary.withValues(alpha: 0.03),
            child: Padding(
              padding:   EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const GoodDeedAvatar(),
                        SizedBox(width: 14.w),
                      Expanded(child: GoodDeedContentText(deed:  widget.deed,)),
                    ],
                  ),
                    SizedBox(height: 16.h),
                  GoodDeedFooter(
                    deed: widget.deed,
                    isLiked: widget.isLiked,
                    onLike: widget.onLike,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }








}
