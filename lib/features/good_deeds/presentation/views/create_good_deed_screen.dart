import '../../../../common_imports.dart';
import '../widgets/create_good_deed_content.dart';
import '../widgets/create_good_deed_header.dart';

class CreateGoodDeedScreen extends StatefulWidget {
  const CreateGoodDeedScreen({super.key});

  @override
  State<CreateGoodDeedScreen> createState() => _CreateGoodDeedScreenState();
}

class _CreateGoodDeedScreenState extends State<CreateGoodDeedScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AdaptiveContainer(
        child: CustomScrollView(
          slivers: [
            CreateGoodDeedHeader(),
            CreateGoodDeedContent(
              fadeAnimation: _fadeAnimation,
            ),
          ],
        ),
      ),
    );
  }









}
