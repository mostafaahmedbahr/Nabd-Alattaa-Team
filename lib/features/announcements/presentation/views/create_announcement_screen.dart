import '../../../../common_imports.dart';
import '../widgets/create_announcement_form.dart';
import '../widgets/create_announcement_header.dart';

class CreateAnnouncementScreen extends StatelessWidget {
  const CreateAnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: AdaptiveContainer(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const CreateAnnouncementHeader(),
              const SliverToBoxAdapter(child: CreateAnnouncementForm()),
            ],
          ),
        ),
      ),
    );
  }
}