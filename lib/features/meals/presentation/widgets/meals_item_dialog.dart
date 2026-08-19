import '../../../../common_imports.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../../data/models/meal_item_model.dart';
import '../view_model/meal_cubit.dart';
import 'meals_category_chips.dart';

void mealsItemDialog(BuildContext context, {MealItemModel? item}) {
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
              padding:   EdgeInsets.all(20.r),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        isEditing ? 'تعديل الوجبة' : 'إضافة وجبة جديدة',
                        style:   TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
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
                    SizedBox(height: 16.h),
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
                    SizedBox(height: 16.h),
                    Text(
                      'القسم',
                      style:   TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    MealsCategoryChips(
                      selectedCategory:  selectedCategory,
                      onSelect:   (category) => setSheetState(() {
                        selectedCategory = category;
                      }),
                    ),
                    SizedBox(height: 16.h),
                    SwitchListTile(
                      value: isAvailable,
                      onChanged: (value) => setSheetState(() {
                        isAvailable = value;
                      }),
                      title: const Text('متاحة للطلب'),
                      contentPadding: EdgeInsets.zero,
                      activeTrackColor: AppColors.success,
                    ),
                    SizedBox(height: 16.h),
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
                          padding:   EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        child: Text(
                          isEditing ? 'حفظ التعديلات' : 'إضافة الوجبة',
                          style:   TextStyle(
                            fontSize: 16.sp,
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