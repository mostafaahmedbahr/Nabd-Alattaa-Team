import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/announcement_model.dart';
import 'announcement_card.dart';

class AnnouncementsList extends StatelessWidget {
  final List<AnnouncementModel> announcements;

  const AnnouncementsList({super.key, required this.announcements});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return AnnouncementCard(announcement: announcements[index]);
          },
          childCount: announcements.length,
        ),
      ),
    );
  }
}