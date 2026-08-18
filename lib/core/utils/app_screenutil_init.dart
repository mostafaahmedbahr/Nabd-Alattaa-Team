import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Like [ScreenUtilInit] but clamps the effective screen width used for
/// scaling, so that on wide screens (web, desktop, tablets) the UI does not
/// get blown up proportionally.
///
/// Everything below [maxScalingWidth] keeps using the real device width,
/// which keeps phones exactly as before.
class AppScreenUtilInit extends StatefulWidget {
  const AppScreenUtilInit({
    super.key,
    required this.child,
    this.designSize = const Size(360, 690),
    this.splitScreenMode = false,
    this.minTextAdapt = false,
    this.fontSizeResolver = FontSizeResolvers.width,
    this.maxScalingWidth = 600,
  });

  final Widget child;
  final Size designSize;
  final bool splitScreenMode;
  final bool minTextAdapt;
  final FontSizeResolver fontSizeResolver;

  /// Maximum screen width (dp) that scales are derived from.
  /// Screens wider than this are treated as if they were this wide.
  final double maxScalingWidth;

  @override
  State<AppScreenUtilInit> createState() => _AppScreenUtilInitState();
}

class _AppScreenUtilInitState extends State<AppScreenUtilInit>
    with WidgetsBindingObserver {
  MediaQueryData? _mediaQueryData;
  final _binding = WidgetsBinding.instance;

  @override
  void initState() {
    super.initState();
    _binding.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _revalidate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _revalidate();
  }

  MediaQueryData? _newData() {
    final view = View.maybeOf(context);
    if (view == null) return null;
    final data = MediaQueryData.fromView(view);
    if (data.size.width > widget.maxScalingWidth) {
      return data.copyWith(
        size: Size(widget.maxScalingWidth, data.size.height),
      );
    }
    return data;
  }

  void _revalidate() {
    final newData = _newData();
    if (newData == null) return;
    if (_mediaQueryData == null || _mediaQueryData!.size != newData.size) {
      setState(() => _mediaQueryData = newData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = _mediaQueryData;
    if (mq == null) return const SizedBox.shrink();

    ScreenUtil.configure(
      data: mq,
      designSize: widget.designSize,
      splitScreenMode: widget.splitScreenMode,
      minTextAdapt: widget.minTextAdapt,
      fontSizeResolver: widget.fontSizeResolver,
    );
    return widget.child;
  }

  @override
  void dispose() {
    _binding.removeObserver(this);
    super.dispose();
  }
}