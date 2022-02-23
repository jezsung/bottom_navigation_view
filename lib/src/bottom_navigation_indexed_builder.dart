import 'package:flutter/widgets.dart';

import 'bottom_navigation_controller.dart';
import 'bottom_navigation_value.dart';
import 'default_bottom_navigation_controller.dart';

class BottomNavigationIndexedBuilder extends StatelessWidget {
  const BottomNavigationIndexedBuilder({
    Key? key,
    this.controller,
    required this.builder,
    this.child,
  }) : super(key: key);

  final BottomNavigationController? controller;
  final ValueWidgetBuilder<int> builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<BottomNavigationValue>(
      valueListenable:
          controller ?? DefaultBottomNavigationController.of(context),
      builder: (context, value, child) {
        return builder(context, value.currentIndex, child);
      },
      child: child,
    );
  }
}
