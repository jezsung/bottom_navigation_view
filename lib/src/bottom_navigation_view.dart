import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'bottom_navigation_controller.dart';
import 'bottom_navigation_transition_type.dart';
import 'bottom_navigation_value.dart';
import 'default_bottom_navigation_controller.dart';
import 'fade_in_out_animation.dart';
import 'fade_through_animation.dart';

class BottomNavigationView extends StatefulWidget {
  const BottomNavigationView({
    Key? key,
    this.controller,
    this.transitionType = BottomNavigationTransitionType.none,
    this.backgroundColor,
    required this.children,
  }) : super(key: key);

  final BottomNavigationController? controller;
  final BottomNavigationTransitionType transitionType;
  final Color? backgroundColor;
  final List<Widget> children;

  @override
  BottomNavigationViewState createState() => BottomNavigationViewState();
}

class BottomNavigationViewState extends State<BottomNavigationView> {
  BottomNavigationController get _controller => widget.controller ?? DefaultBottomNavigationController.of(context);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<BottomNavigationValue>(
      valueListenable: _controller,
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
            return Container(
              color: widget.backgroundColor ?? Theme.of(context).backgroundColor,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  for (final child in otherChildren) Offstage(child: child),
                  FadeThroughAnimation(
                    animation: _controller.animation,
                    outgoingChild: prevChild,
                    ingoingChild: currChild,
                  ),
                ],
              ),
            );
          case BottomNavigationTransitionType.fadeInOut:
            return Stack(
              fit: StackFit.expand,
              children: [
                for (final child in otherChildren) Offstage(child: child),
                FadeInOutAnimation(
                  animation: _controller.animation,
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
