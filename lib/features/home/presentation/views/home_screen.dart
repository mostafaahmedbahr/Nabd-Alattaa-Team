import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nabd_alattaa_team/features/tasks/presentation/views/tasks_screen.dart';

import '../../../../core/router/app_routes.dart';
import '../view_model/home_cubit.dart';
import '../view_model/home_states.dart';
import '../widgets/welcome_section.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/announcements_section.dart';
import '../widgets/tasks_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<HomeCubit>().loadHomeData(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WelcomeSection(),
            const SizedBox(height: 24),
            const QuickActionsGrid(),
            const SizedBox(height: 24),
            // BlocBuilder<HomeCubit, HomeStates>(
            //   builder: (context, state) {
            //     if (state is HomeLoading) {
            //       return const Center(child: CircularProgressIndicator());
            //     }
            //     if (state is HomeLoaded) {
            //       return Column(
            //         children: [
            //           AnnouncementsSection(
            //             announcements: state.announcements,
            //           ),
            //           const SizedBox(height: 24),
            //           TasksSection(tasks: state.tasks),
            //         ],
            //       );
            //     }
            //     if (state is HomeError) {
            //       return Center(child: Text(state.message));
            //     }
            //     return const SizedBox.shrink();
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
