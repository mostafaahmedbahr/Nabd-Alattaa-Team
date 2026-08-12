import '../../../../common_imports.dart';
import 'announcement_section_title.dart';

class AnnouncementFormSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const AnnouncementFormSection({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnnouncementSectionTitle(title: title, icon: icon),
        SizedBox(height: 12.h),
        child,
      ],
    );
  }
}