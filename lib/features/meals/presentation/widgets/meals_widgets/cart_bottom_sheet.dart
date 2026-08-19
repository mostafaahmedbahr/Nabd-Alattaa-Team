import 'package:flutter/material.dart';

import '../cart_bottom_sheet.dart';

void showCartBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const CartBottomSheet(),
  );
}