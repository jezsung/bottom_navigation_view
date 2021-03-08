import 'package:flutter/widgets.dart';

import 'bottom_navigation_controller.dart';
import 'bottom_navigation_value.dart';

class BottomNavigationBarBuilder extends StatefulWidget {
  const BottomNavigationBarBuilder({
    Key? key,
    required this.controller,
    required this.builder,
    this.child,
  }) : super(key: key);

  final BottomNavigationController controller;
  final Widget Function(BuildContext context, int index, Widget? child) builder;
  final Widget? child;

  @override
  BottomNavigationBarBuilderState createState() => BottomNavigationBarBuilderState();
}

class BottomNavigationBarBuilderState extends State<BottomNavigationBarBuilder> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<BottomNavigationValue>(
      valueListenable: widget.controller,
      builder: (context, value, child) {
        return widget.builder(context, value.currentIndex, child);
      },
      child: widget.child,
    );
  }
}
