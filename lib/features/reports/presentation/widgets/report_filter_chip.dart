import '../../../../common_imports.dart';

class ReportFilterChip extends StatelessWidget {
  const ReportFilterChip({
    super.key,
    required this.label,
    required this.filter,
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.color,
  });

  final String label;
  final String filter;
  final String selectedFilter;
  final void Function(String filter) onFilterSelected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedFilter == filter;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            onFilterSelected(filter);
          }
        },
        selectedColor: color,
        backgroundColor: AppColors.surface,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 13,
        ),
        checkmarkColor: AppColors.textWhite,
        side: BorderSide(
          color: isSelected ? color : AppColors.border,
          width: isSelected ? 0 : 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
