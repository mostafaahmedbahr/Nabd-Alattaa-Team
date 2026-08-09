import '../../../../common_imports.dart';
import '../../data/models/good_deed_model.dart';

class GoodDeedLikeButton extends StatefulWidget {
  const GoodDeedLikeButton({
    super.key,
    required this.deed,
    required this.isLiked,
    required this.onLike,
  });

  final GoodDeedModel deed;
  final bool isLiked;
  final VoidCallback onLike;

  @override
  State<GoodDeedLikeButton> createState() => _GoodDeedLikeButtonState();
}

class _GoodDeedLikeButtonState extends State<GoodDeedLikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartController;
  late Animation<double> _heartScale;

  @override
  void initState() {
    super.initState();

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _heartScale = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _heartController, curve: Curves.easeOut));
  }

  void _onLikeTap() {
    _heartController.forward().then((_) {
      _heartController.reverse();
    });

    widget.onLike();
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onLikeTap,
      child: AnimatedBuilder(
        animation: _heartScale,
        builder: (context, child) {
          return Transform.scale(scale: _heartScale.value, child: child);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color:  AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isLiked ? AppColors.secondaryDark : AppColors.grey200,
              width: 1.w,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.isLiked
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                size: 16.sp,
                color: widget.isLiked ? AppColors.secondaryDark : AppColors.grey400,
              ),

              SizedBox(width: 6.w),

              Text(
                widget.deed.likesCount.toString(),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: widget.isLiked
                      ? AppColors.secondaryDark
                      : AppColors.grey500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
