import 'package:flutter/material.dart';

import 'bottom_navigation_controller.dart';
import 'bottom_navigation_value.dart';

class DefaultBottomNavigationController extends StatefulWidget {
  const DefaultBottomNavigationController({
    Key? key,
    this.initialIndex = 0,
    this.transitionDuration = const Duration(milliseconds: 300),
    required this.child,
  }) : super(key: key);

  DefaultBottomNavigationController.fromValue(
    BottomNavigationValue value, {
    Key? key,
    this.transitionDuration = const Duration(milliseconds: 300),
    required this.child,
  })  : initialIndex = value.currentIndex,
        super(key: key);

  final int initialIndex;
  final Duration transitionDuration;
  final Widget child;

  static BottomNavigationController of(BuildContext context) {
    final _BottomNavigationControllerScope? scope = context
        .dependOnInheritedWidgetOfExactType<_BottomNavigationControllerScope>();
    if (scope == null) {
      throw StateError(
        'DefaultBottomNavigationController.of() called with a context that does not contain a Scaffold.',
      );
    }
    return scope.controller;
  }

  @override
  _DefaultBottomNavigationControllerState createState() =>
      _DefaultBottomNavigationControllerState();
}

class _DefaultBottomNavigationControllerState
    extends State<DefaultBottomNavigationController>
    with SingleTickerProviderStateMixin {
  late final BottomNavigationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BottomNavigationController(
      vsync: this,
      duration: widget.transitionDuration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BottomNavigationControllerScope(
      controller: _controller,
      enabled: TickerMode.of(context),
      child: widget.child,
    );
  }
}

class _BottomNavigationControllerScope extends InheritedWidget {
  const _BottomNavigationControllerScope({
    Key? key,
    required this.controller,
    required this.enabled,
    required Widget child,
  }) : super(key: key, child: child);

  final BottomNavigationController controller;
  final bool enabled;

  @override
  bool updateShouldNotify(_BottomNavigationControllerScope old) {
    return enabled != old.enabled || controller != old.controller;
  }
}
