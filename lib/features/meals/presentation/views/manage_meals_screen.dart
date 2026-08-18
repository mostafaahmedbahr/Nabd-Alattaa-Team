import 'package:firebase_auth/firebase_auth.dart';

import '../../../../common_imports.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../../../profile/presentation/view_model/profile_cubit.dart';
import '../../../profile/presentation/view_model/profile_state.dart';
import '../../data/models/meal_item_model.dart';
import '../view_model/meal_cubit.dart';
import '../view_model/meal_state.dart';

class ManageMealsScreen extends StatefulWidget {
  const ManageMealsScreen({super.key});

  @override
  State<ManageMealsScreen> createState() => _ManageMealsScreenState();
}

class _ManageMealsScreenState extends State<ManageMealsScreen> {
  @override
  void initState() {
    super.initState();
    _checkAccess();
    context.read<MealCubit>().loadMenu();
  }

  Future<void> _checkAccess() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _kickOut();
      return;
    }

    final cubit = context.read<ProfileCubit>();
    if (cubit.state is! ProfileLoaded) {
      await cubit.loadProfile(user.uid);
    }

    if (!mounted) return;

    final state = cubit.state;
    if (state is ProfileLoaded && state.profile.isAdmin) {
      return;
    }

    _kickOut();
  }

  void _kickOut() {
    if (!mounted) return;
    Navigator.of(context).maybePop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('غير مصرح لك بالوصول لهذه الصفحة'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إدارة قائمة الطعام'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showItemDialog(context),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add_rounded, color: AppColors.textWhite),
          label: const Text(
            'إضافة أكلة',
            style: TextStyle(
              color: AppColors.textWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocConsumer<MealCubit, MealState>(
          listener: (context, state) {
            if (state is MealItemSaved) {
              _showSnackBar(context, 'تم حفظ الوجبة بنجاح', AppColors.success);
            } else if (state is MealItemDeleted) {
              _showSnackBar(context, 'تم حذف الوجبة', AppColors.success);
            } else if (state is MealError) {
              _showSnackBar(context, state.message, AppColors.error);
            }
          },
          builder: (context, state) {
            final cubit = context.read<MealCubit>();

            if (state is MealLoading && cubit.menuItems.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MealError && state.message.contains('فشل')) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 56,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 12),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<MealCubit>().loadMenu(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            if (cubit.menuItems.isEmpty) {
              return _buildEmptyState();
            }

            return _buildGroupedList(cubit.menuItems);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.restaurant_menu_outlined,
              size: 64,
              color: AppColors.grey400,
            ),
            const SizedBox(height: 16),
            const Text(
              'لا توجد وجبات بعد',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'اضغط على زر إضافة أكلة لإضافة أول وجبة',
              style: TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showItemDialog(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('إضافة أكلة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupedList(List<MealItemModel> items) {
    final grouped = <String, List<MealItemModel>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }

    final categories = grouped.keys.toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
      children: [
        for (final category in categories) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.category_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  category.isEmpty ? 'بدون قسم' : category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${grouped[category]!.length})',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          for (final item in grouped[category]!)
            _buildItemCard(item),
        ],
      ],
    );
  }

  Widget _buildItemCard(MealItemModel item) {
    final cubit = context.read<MealCubit>();
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.fastfood_outlined,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.price.toStringAsFixed(0)} ر.س',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.secondaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Switch(
                  value: item.isAvailable,
                  onChanged: (_) => cubit.toggleAvailability(item.id),
                  activeTrackColor: AppColors.success,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                Text(
                  item.isAvailable ? 'متاح' : 'غير متاح',
                  style: TextStyle(
                    fontSize: 11,
                    color: item.isAvailable
                        ? AppColors.success
                        : AppColors.error,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () => _showItemDialog(context, item: item),
              icon: const Icon(Icons.edit_outlined, size: 20),
              color: AppColors.primary,
            ),
            IconButton(
              onPressed: () => _confirmDelete(item),
              icon: const Icon(Icons.delete_outline, size: 20),
              color: AppColors.error,
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(MealItemModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الوجبة'),
        content: Text('هل أنت متأكد من حذف "${item.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<MealCubit>().deleteMealItem(item.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showItemDialog(BuildContext context, {MealItemModel? item}) {
    final isEditing = item != null;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: item?.name ?? '');
    final priceController = TextEditingController(
      text: item != null ? '${item.price}' : '',
    );
    String selectedCategory = item?.category ?? MealCategory.sandwiches;
    bool isAvailable = item?.isAvailable ?? true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: StatefulBuilder(
          builder: (context, setSheetState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          isEditing ? 'تعديل الوجبة' : 'إضافة وجبة جديدة',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: nameController,
                        labelText: 'اسم الأكلة',
                        prefixIcon: Icons.fastfood_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'اسم الأكلة مطلوب';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: priceController,
                        labelText: 'السعر (ر.س)',
                        prefixIcon: Icons.attach_money,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          final price = double.tryParse(value ?? '');
                          if (value == null || value.trim().isEmpty) {
                            return 'السعر مطلوب';
                          }
                          if (price == null || price <= 0) {
                            return 'أدخل سعر صحيح أكبر من صفر';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'القسم',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildCategoryChips(
                        selectedCategory,
                        (category) => setSheetState(() {
                          selectedCategory = category;
                        }),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        value: isAvailable,
                        onChanged: (value) => setSheetState(() {
                          isAvailable = value;
                        }),
                        title: const Text('متاحة للطلب'),
                        contentPadding: EdgeInsets.zero,
                        activeTrackColor: AppColors.success,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;

                            final mealItem = MealItemModel(
                              id: item?.id ?? '',
                              name: nameController.text.trim(),
                              price: double.parse(priceController.text.trim()),
                              category: selectedCategory,
                              isAvailable: isAvailable,
                            );

                            Navigator.pop(context);

                            final cubit = context.read<MealCubit>();
                            if (isEditing) {
                              cubit.updateMealItem(mealItem);
                            } else {
                              cubit.addMealItem(mealItem);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textWhite,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            isEditing ? 'حفظ التعديلات' : 'إضافة الوجبة',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryChips(
    String selectedCategory,
    void Function(String) onSelect,
  ) {
    final categories = MealCategory.all;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        final isSelected = category == selectedCategory;
        return ChoiceChip(
          label: Text(category),
          selected: isSelected,
          onSelected: (_) => onSelect(category),
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
          checkmarkColor: AppColors.textWhite,
        );
      }).toList(),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}
