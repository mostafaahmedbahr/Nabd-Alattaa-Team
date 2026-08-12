import '../../../../common_imports.dart';
import '../view_model/announcement_cubit.dart';
import '../view_model/announcement_state.dart';
import '../widgets/announcements_empty_state.dart';
import '../widgets/announcements_error_state.dart';
import '../widgets/announcements_header.dart';
import '../widgets/announcements_list.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AnnouncementCubit>().loadAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const AnnouncementsScreenHeader(),
            BlocBuilder<AnnouncementCubit, AnnouncementState>(
              builder: (context, state) {
                if (state is AnnouncementLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  );
                }

                if (state is AnnouncementError) {
                  return AnnouncementsErrorState(
                    message: state.message,
                    onRetry: () =>
                        context.read<AnnouncementCubit>().loadAnnouncements(),
                  );
                }

                if (state is AnnouncementLoaded) {
                  if (state.announcements.isEmpty) {
                    return const AnnouncementsEmptyState();
                  }
                  return AnnouncementsList(announcements: state.announcements);
                }

                return const SliverFillRemaining(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final cubit = context.read<AnnouncementCubit>();
          await context.push(Routes.createAnnouncement);
          if (mounted) {
            cubit.loadAnnouncements();
          }
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: Icon(Icons.add_rounded, size: 24.sp),
        label: Text(
          'إعلان جديد',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
        ),
      ),
    );
  }
}