import 'package:url_launcher/url_launcher.dart';

import '../../../../common_imports.dart';
import '../../data/models/user_profile_model.dart';
import 'info_row.dart';

class InfoSection extends StatelessWidget {
  const InfoSection({super.key, required this.userProfileModel});
  final UserProfileModel userProfileModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              InfoRow(
                Icons.email_outlined,
                AppStrings.email,
                userProfileModel.email,
                onTap: () async {
                  final email = userProfileModel.email;

                  if (email.isEmpty) return;

                  final uri = Uri(
                    scheme: 'mailto',
                    path: email,
                  );

                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
              ),              const Divider(),
              InfoRow(Icons.phone_outlined, AppStrings.phone, userProfileModel.phone),

              const Divider(),
               InfoRow(Icons.business_outlined, AppStrings.department, userProfileModel.department),
              const Divider(),
               InfoRow(Icons.work_outlined, AppStrings.position, userProfileModel.position),
              const Divider(),
               InfoRow(Icons.calendar_today_outlined, 'تاريخ التسجيل',
                  _formatDate(userProfileModel.createdAt)),
            ],
          ),
        ),
      ),
    );
  }
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
