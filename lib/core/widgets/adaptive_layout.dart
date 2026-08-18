import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Convenience helpers built on top of [ResponsiveBreakpoints.of].
extension ResponsiveX on BuildContext {
  ResponsiveBreakpointsData get responsive =>
      ResponsiveBreakpoints.of(this);

  bool get isMobile => responsive.isMobile;

  bool get isPhone => responsive.isPhone;

  bool get isTablet => responsive.isTablet;

  bool get isDesktop => responsive.isDesktop;

  /// Wide enough to show a persistent side rail and constrained content:
  /// tablets in landscape or desktops.
  bool get isWideScreen => responsive.screenWidth >= 800;
}

/// Centers the [child] on wide screens (tablet/desktop) and constrains its
/// width so content does not stretch across the full window.
/// On mobile it is a no-op.
class AdaptiveContainer extends StatelessWidget {
  const AdaptiveContainer({
    super.key,
    required this.child,
    this.maxWidth = 760,
    this.center = true,
  });

  final Widget child;
  final double maxWidth;
  final bool center;

  @override
  Widget build(BuildContext context) {
    if (!context.isWideScreen || !center) {
      return context.isWideScreen
          ? ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: child,
            )
          : child;
    }
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// Constrains a form-like screen content to [maxWidth] on wide screens.
class AdaptiveFormContainer extends StatelessWidget {
  const AdaptiveFormContainer({
    super.key,
    required this.child,
    this.maxWidth = 640,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    if (!context.isWideScreen) return child;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}