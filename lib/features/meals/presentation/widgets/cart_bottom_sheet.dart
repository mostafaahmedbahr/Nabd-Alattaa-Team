import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/meal_cubit.dart';
import '../view_model/meal_state.dart';

class CartBottomSheet extends StatelessWidget {
  const CartBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                _buildHandle(),
                _buildHeader(),
                Expanded(
                  child: BlocBuilder<MealCubit, MealState>(
                    builder: (context, state) {
                      final cubit = context.read<MealCubit>();
                      if (cubit.cartItems.isEmpty) {
                        return const Center(
                          child: Text(
                            'السلة فارغة',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }
                      return _buildCartList(cubit, scrollController);
                    },
                  ),
                ),
                _buildTotalAndOrderButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'سلة الوجبات',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCartList(
      MealCubit cubit, ScrollController scrollController) {
    return ListView.builder(
      controller: scrollController,
      itemCount: cubit.cartOrderItems.length,
      itemBuilder: (context, index) {
        final item = cubit.cartOrderItems[index];
        return ListTile(
          title: Text(item.name),
          subtitle: Text(
            '${item.quantity} × ${item.price.toStringAsFixed(0)} ر.س',
          ),
          trailing: Text(
            '${item.subtotal.toStringAsFixed(0)} ر.س',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              for (var i = 0; i < item.quantity; i++) {
                cubit.removeFromCart(item.itemId);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildTotalAndOrderButton(BuildContext context) {
    return BlocBuilder<MealCubit, MealState>(
      builder: (context, state) {
        final cubit = context.read<MealCubit>();
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الإجمالي:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${cubit.cartTotal.toStringAsFixed(0)} ر.س',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: cubit.cartItems.isEmpty
                      ? null
                      : () => _submitOrder(context, cubit),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: state is MealOrderSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'تأكيد الطلب',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitOrder(BuildContext context, MealCubit cubit) {
    cubit.submitOrder('current_user_id', 'المستخدم الحالي');
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تأكيد الطلب بنجاح'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
