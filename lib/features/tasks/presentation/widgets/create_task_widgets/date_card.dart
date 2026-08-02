import 'package:intl/intl.dart';

import '../../../../../common_imports.dart';

class DateCard extends StatefulWidget {
  const DateCard({super.key});

  @override
  State<DateCard> createState() => _DateCardState();
}

class _DateCardState extends State<DateCard> {
  @override
  Widget build(BuildContext context) {
    DateTime dueDate = DateTime.now().add(const Duration(days: 1));
    final date = DateFormat('dd MMMM yyyy', 'ar').format(dueDate);
    final isToday = DateUtils.isSameDay(dueDate, DateTime.now());
    final isTomorrow = DateUtils.isSameDay(
      dueDate,
      DateTime.now().add(const Duration(days: 1)),
    );

    String dateLabel = date;
    if (isToday) dateLabel = "اليوم - $date";
    if (isTomorrow) dateLabel = "غداً - $date";
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: dueDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: AppColors.textPrimary,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() => dueDate = picked);
        }
      },
      child: Container(
        padding:   EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child:   Icon(
                Icons.calendar_today_rounded,
                color: AppColors.primary,
                size: 20.sp,
              ),
            ),
              SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                    "موعد التسليم",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.grey500,
                    ),
                  ),
                    SizedBox(height: 4.h),
                  Text(
                    dateLabel,
                    style:   TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
              Icon(
              Icons.arrow_drop_down_rounded,
              color: AppColors.grey400,
              size: 28.sp,
            ),
          ],
        ),
      ),
    );
  }
}
