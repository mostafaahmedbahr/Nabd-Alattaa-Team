import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool centerTitle;
  final double elevation;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.centerTitle = true,
    this.elevation = 0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? AppColors.textWhite,
      leading: showBackButton
          ? leading ??
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => context.pop(),
              )
          : leading,
      actions: actions,
    );
  }
}
