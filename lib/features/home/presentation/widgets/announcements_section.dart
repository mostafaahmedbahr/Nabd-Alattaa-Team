import 'package:flutter/material.dart';

import 'announcement_card.dart';
import 'section_header.dart';

class AnnouncementsSection extends StatelessWidget {
  final List<Map<String, dynamic>> announcements;

  const AnnouncementsSection({super.key, required this.announcements});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'آخر الإعلانات',
          onSeeAll: () {},
        ),
        const SizedBox(height: 8),
        if (announcements.isEmpty)
          const Center(child: Text('لا توجد إعلانات'))
        else
          ...announcements.map((a) => AnnouncementCard(
                title: a['title'] ?? '',
                subtitle: a['subtitle'] ?? '',
                time: a['time'] ?? '',
              )),
      ],
    );
  }
}
