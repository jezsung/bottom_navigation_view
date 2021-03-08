import 'package:flutter/widgets.dart';

import 'bottom_navigation_controller.dart';
import 'bottom_navigation_transition_type.dart';
import 'bottom_navigation_value.dart';
import 'fade_through_animation.dart';
import 'cross_fade_animation.dart';

class BottomNavigationBody extends StatefulWidget {
  const BottomNavigationBody({
    Key? key,
    required this.controller,
    required this.children,
    this.transitionType = BottomNavigationTransitionType.none,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  final BottomNavigationController controller;
  final List<Widget> children;
  final BottomNavigationTransitionType transitionType;
  final Duration duration;

  @override
  BottomNavigationBodyState createState() => BottomNavigationBodyState();
}

class BottomNavigationBodyState extends State<BottomNavigationBody> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: 1.0,
      vsync: this,
      duration: widget.duration,
    );
    widget.controller.addListener(() async {
      try {
        _controller.reset();
        await _controller.forward().orCancel;
      } on TickerCanceled {
        // The animation got canceled
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BottomNavigationBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<BottomNavigationValue>(
      valueListenable: widget.controller,
      builder: (context, value, child) {
        final prevIndex = value.previousIndex;
        final currIndex = value.currentIndex;
        final prevChild = prevIndex != null ? widget.children[prevIndex] : Container();
        final currChild = widget.children[currIndex];
        final otherChildren = widget.children.where((child) => child != prevChild && child != currChild).toList();

        switch (widget.transitionType) {
          case BottomNavigationTransitionType.none:
            return Stack(
              fit: StackFit.expand,
              children: [
                for (final child in otherChildren..add(prevChild)) Offstage(child: child),
                currChild,
              ],
            );
          case BottomNavigationTransitionType.fadeThrough:
            return Stack(
              fit: StackFit.expand,
              children: [
                for (final child in otherChildren) Offstage(child: child),
                FadeThroughAnimation(
                  controller: _controller,
                  outgoingChild: prevChild,
                  ingoingChild: currChild,
                ),
              ],
            );
          case BottomNavigationTransitionType.fadeInOut:
            return Stack(
              fit: StackFit.expand,
              children: [
                for (final child in otherChildren) Offstage(child: child),
                CrossFadeAnimation(
                  controller: _controller,
                  outgoingChild: prevChild,
                  ingoingChild: currChild,
                ),
              ],
            );
          default:
            throw UnimplementedError();
        }
      },
    );
  }
}
