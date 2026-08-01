import 'package:flutter/material.dart';

import 'section_header.dart';
import 'task_card.dart';

class TasksSection extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;

  const TasksSection({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'آخر المهام',
          onSeeAll: () {},
        ),
        const SizedBox(height: 8),
        if (tasks.isEmpty)
          const Center(child: Text('لا توجد مهام'))
        else
          ...tasks.map((t) => TaskCard(
                title: t['title'] ?? '',
                subtitle: t['subtitle'] ?? '',
                status: t['status'] ?? '',
                statusColor: t['statusColor'] ?? Colors.grey,
              )),
      ],
    );
  }
}
