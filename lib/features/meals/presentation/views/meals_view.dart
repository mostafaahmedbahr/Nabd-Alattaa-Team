import 'package:nabd_alattaa_team/features/meals/presentation/widgets/meals_widgets/meals_view_body.dart';
import '../../../../common_imports.dart';
import '../widgets/meals_widgets/cart_fab.dart';


class MealsView extends StatefulWidget {
  const MealsView({super.key});

  @override
  State<MealsView> createState() => _MealsViewState();
}

class _MealsViewState extends State<MealsView> {


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: MealsViewBody(),
        floatingActionButton: CartFab(),
      ),
    );
  }










}


