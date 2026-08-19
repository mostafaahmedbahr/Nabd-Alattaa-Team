import '../../../../common_imports.dart';
import '../../data/models/meal_order_model.dart';
import '../view_model/meal_cubit.dart';
import '../view_model/meal_state.dart';
import 'meals_snack_bar.dart';

class MealOrdersViewBody extends StatefulWidget {
  const MealOrdersViewBody({super.key});

  @override
  State<MealOrdersViewBody> createState() => _MealOrdersViewBodyState();
}

class _MealOrdersViewBodyState extends State<MealOrdersViewBody> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MealCubit, MealState>(
      listener: (context, state) {
        if (state is MealPaymentUpdated) {
          context.read<MealCubit>().loadOrders(DateTime.now());
        } else if (state is MealError) {
          mealsShowSnackBar(context, state.message, AppColors.error);
        }
      },
      builder: (context, state) {
        final cubit = context.read<MealCubit>();

        if (state is MealLoading && cubit.orders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MealError && cubit.orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 56.sp, color: AppColors.error),
                SizedBox(height: 12.h),
                Text(state.message, textAlign: TextAlign.center),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () =>
                      context.read<MealCubit>().loadOrders(DateTime.now()),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        if (cubit.orders.isEmpty) {
          return const _EmptyOrders();
        }

        final orders = cubit.orders;
        return AdaptiveContainer(
          child: RefreshIndicator(
            onRefresh: () =>
                context.read<MealCubit>().loadOrders(DateTime.now()),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.r),
              children: [
                _HeaderDate(),
                SizedBox(height: 16.h),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cellWidth = (constraints.maxWidth - 12.r) / 2;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: cellWidth,
                          child: _SummaryCard(
                            title: 'إجمالي الطلبات',
                            value: '${orders.length}',
                            icon: Icons.receipt_long_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 12.r),
                        SizedBox(
                          width: cellWidth,
                          child: _SummaryCard(
                            title: 'إجمالي الأصناف',
                            value: '$totalItems',
                            icon: Icons.fastfood_outlined,
                            color: AppColors.secondaryDark,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 12.h),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cellWidth = (constraints.maxWidth - 12.r) / 2;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: cellWidth,
                          child: _SummaryCard(
                            title: 'إجمالي المبلغ',
                            value: '${totalRevenue.toStringAsFixed(0)} ر.س',
                            icon: Icons.payments_outlined,
                            color: AppColors.success,
                          ),
                        ),
                        SizedBox(width: 12.r),
                        SizedBox(
                          width: cellWidth,
                          child: _SummaryCard(
                            title: 'غير مدفوعة',
                            value: '$unpaidCount',
                            icon: Icons.pending_actions_outlined,
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 24.h),
                _AggregatedItemsSection(orders: orders),
                SizedBox(height: 24.h),
                Text(
                  'تفاصيل الطلبات (${orders.length})',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                ...orders.map((order) => _OrderCard(order: order)),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      },
    );
  }

  int get totalItems {
    final orders = context.read<MealCubit>().orders;
    return orders.fold(
      0,
      (sum, order) => sum + order.items.fold(0, (s, item) => s + item.quantity),
    );
  }

  double get totalRevenue {
    final orders = context.read<MealCubit>().orders;
    return orders.fold(0.0, (sum, order) => sum + order.total);
  }

  int get unpaidCount {
    final orders = context.read<MealCubit>().orders;
    return orders.where((order) => !order.isPaid).length;
  }
}

String _twoDigits(int value) => value.toString().padLeft(2, '0');

String _formatTime(DateTime date) =>
    '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';

class _HeaderDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Row(
      children: [
        Icon(Icons.today, size: 18.sp, color: AppColors.primary),
        SizedBox(width: 8.w),
        Text(
          'طلبات اليوم — ${now.day}/${now.month}/${now.year}',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92.h,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: color, size: 22.sp),
            ),
          ],
        ),
      ),
    );
  }
}

class _AggregatedItemsSection extends StatelessWidget {
  final List<MealOrderModel> orders;

  const _AggregatedItemsSection({required this.orders});

  @override
  Widget build(BuildContext context) {
    final aggregated = <String, int>{};
    double spent = 0;
    for (final order in orders) {
      for (final item in order.items) {
        aggregated[item.name] = (aggregated[item.name] ?? 0) + item.quantity;
        spent += item.subtotal;
      }
    }

    final sorted = aggregated.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shopping_basket_outlined,
                size: 18.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: 8.w),
              Text(
                'إجمالي الطلبات (تجميع كل الأصناف)',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (final entry in sorted)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    '${entry.key} × ${entry.value}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(height: 1.h, color: AppColors.grey200),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'قيمة المبيعات',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${spent.toStringAsFixed(0)} ر.س',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final MealOrderModel order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200, width: 1),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_outline,
                    size: 20.sp,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _formatTime(order.date),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${order.total.toStringAsFixed(0)} ر.س',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    GestureDetector(
                      onTap: () => context
                          .read<MealCubit>()
                          .updatePaymentStatus(order.id, !order.isPaid),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: order.isPaid
                              ? Colors.green.withValues(alpha: 0.12)
                              : AppColors.warning.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              order.isPaid
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              size: 14.sp,
                              color: order.isPaid
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              order.isPaid ? 'مدفوع' : 'غير مدفوع',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: order.isPaid
                                    ? AppColors.success
                                    : AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1.h, color: AppColors.grey200),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            child: Column(
              children: [
                for (final item in order.items)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '× ${item.quantity}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        SizedBox(
                          width: 76.w,
                          child: Text(
                            '${item.subtotal.toStringAsFixed(0)} ر.س',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.confirmation_number_outlined,
                      size: 14.sp,
                      color: AppColors.grey400,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        'رقم المرجع: ${order.id}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.grey400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64.sp,
            color: AppColors.grey300,
          ),
          SizedBox(height: 16.h),
          Text(
            'لا توجد طلبات اليوم بعد',
            style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: () =>
                context.read<MealCubit>().loadOrders(DateTime.now()),
            icon: const Icon(Icons.refresh),
            label: const Text('تحديث'),
          ),
        ],
      ),
    );
  }
}
