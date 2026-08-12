import '../../../../common_imports.dart';

class AnnouncementTypeSelector extends StatefulWidget {
  final String selectedType;
  final ValueChanged<String> onChanged;

  const AnnouncementTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  State<AnnouncementTypeSelector> createState() => _AnnouncementTypeSelectorState();
}

class _AnnouncementTypeSelectorState extends State<AnnouncementTypeSelector> {
  static const _types = [
    ('أخبار', 'news', Icons.campaign_rounded),
    ('اجتماع', 'meeting', Icons.event_rounded),
    ('عطلة', 'holiday', Icons.beach_access_rounded),
    ('قرار', 'decision', Icons.gavel_rounded),
    ('تنبيه', 'alert', Icons.warning_amber_rounded),
  ];

  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedType;
  }

  @override
  void didUpdateWidget(covariant AnnouncementTypeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedType != _selected) {
      _selected = widget.selectedType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: _types.map((type) {
        final isSelected = _selected == type.$2;
        return GestureDetector(
          onTap: () {
            setState(() => _selected = type.$2);
            widget.onChanged(_selected);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  type.$3,
                  size: 16.r,
                  color: isSelected ? AppColors.textWhite : AppColors.primary,
                ),
                SizedBox(width: 6.w),
                Text(
                  type.$1,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}