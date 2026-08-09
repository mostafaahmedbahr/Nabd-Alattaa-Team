import 'package:nabd_alattaa_team/features/good_deeds/presentation/widgets/content.dart';
import '../../../../common_imports.dart';
import '../view_model/good_deed_cubit.dart';
import '../view_model/good_deed_state.dart';
import '../widgets/header.dart';

class GoodDeedsScreen extends StatefulWidget {
  const GoodDeedsScreen({super.key});

  @override
  State<GoodDeedsScreen> createState() => _GoodDeedsScreenState();
}

class _GoodDeedsScreenState extends State<GoodDeedsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GoodDeedCubit>().loadGoodDeeds();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<GoodDeedCubit, GoodDeedState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<GoodDeedCubit>().loadGoodDeeds();
            },
            color: AppColors.secondary,
            child: CustomScrollView(
              slivers: [
                Header(),
                GoodDeedContent(
                  state: state,)
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final cubit = context.read<GoodDeedCubit>();
          await context.push(Routes.createGoodDeed);
          if (mounted) {
            cubit.loadGoodDeeds();
          }
        },
        backgroundColor: AppColors.secondary,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, color: AppColors.textWhite, size: 28),
        label: const Text(
          'عمل جديد',
          style: TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }




}


