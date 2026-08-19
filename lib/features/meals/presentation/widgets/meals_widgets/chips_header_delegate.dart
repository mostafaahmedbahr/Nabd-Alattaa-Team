import '../../../../../common_imports.dart';

class ChipsHeaderDelegate extends SliverPersistentHeaderDelegate
{
  ChipsHeaderDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 62;

  @override
  double get maxExtent => 62;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant ChipsHeaderDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}