import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../data/models/good_deed_model.dart';

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
  late Animation<double> _heartScale;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heartScale = TweenSequence<double>([
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

  void _onLikeTap() {
    _heartController.forward(from: 0.0);
    widget.onLike();
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
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.grey100,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: widget.onTap,
            splashColor: AppColors.secondary.withValues(alpha: 0.05),
            highlightColor: AppColors.secondary.withValues(alpha: 0.03),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAvatar(),
                      const SizedBox(width: 14),
                      Expanded(child: _buildContent()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.secondary,
            AppColors.secondaryDark,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.volunteer_activism_rounded,
        color: AppColors.textWhite,
        size: 24,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.deed.title.isNotEmpty ? widget.deed.title : widget.deed.content,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
        if (widget.deed.title.isNotEmpty && widget.deed.content.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            widget.deed.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule_rounded,
            size: 14,
            color: AppColors.grey400,
          ),
          const SizedBox(width: 6),
          Text(
            Helpers.timeAgo(widget.deed.createdAt),
            style: const TextStyle(
              color: AppColors.textHint,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          _buildLikeButton(),
        ],
      ),
    );
  }

  Widget _buildLikeButton() {
    return GestureDetector(
      onTap: _onLikeTap,
      child: AnimatedBuilder(
        animation: _heartScale,
        builder: (context, child) {
          return Transform.scale(
            scale: _heartScale.value,
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: widget.isLiked
                ? AppColors.error.withValues(alpha: 0.1)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isLiked
                  ? AppColors.error.withValues(alpha: 0.2)
                  : AppColors.grey200,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.isLiked
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                size: 16,
                color: widget.isLiked ? AppColors.error : AppColors.grey400,
              ),
              const SizedBox(width: 6),
              Text(
                widget.deed.likesCount.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: widget.isLiked ? AppColors.error : AppColors.grey500,
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
