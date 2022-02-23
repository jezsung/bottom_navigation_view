import 'package:flutter/material.dart';

import 'bottom_navigation_controller.dart';
import 'bottom_navigation_transition_type.dart';
import 'bottom_navigation_value.dart';
import 'default_bottom_navigation_controller.dart';

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
  BottomNavigationController get _controller =>
      widget.controller ?? DefaultBottomNavigationController.of(context);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<BottomNavigationValue>(
      valueListenable: _controller,
      builder: (context, value, child) {
        final Animation<double> animation = _controller.animation;
        final int? prevIndex = value.previousIndex;
        final int currIndex = value.currentIndex;

        switch (widget.transitionType) {
          case BottomNavigationTransitionType.none:
            return Stack(
              fit: StackFit.expand,
              children: [
                for (int i = 0; i < widget.children.length; i++)
                  Offstage(
                    offstage: i != currIndex,
                    child: widget.children[i],
                  ),
              ],
            );
          case BottomNavigationTransitionType.fadeThrough:
            return Container(
              color:
                  widget.backgroundColor ?? Theme.of(context).backgroundColor,
              child: Stack(
                fit: StackFit.expand,
                children: widget.children.map((child) {
                  final int index = widget.children.indexOf(child);

                  return AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      final bool offstage;
                      final double opacity;
                      final double scale;

                      if (index == currIndex) {
                        offstage = false;
                      } else if (index == prevIndex) {
                        offstage = animation.isCompleted;
                      } else {
                        offstage = true;
                      }

                      if (index == prevIndex) {
                        opacity = Tween<double>(begin: 1.0, end: 0.0)
                            .animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: const Interval(0.0, 0.3),
                              ),
                            )
                            .value;
                      } else if (index == currIndex) {
                        opacity = Tween<double>(begin: 0.0, end: 1.0)
                            .animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: const Interval(0.3, 1.0),
                              ),
                            )
                            .value;
                      } else {
                        opacity = 1.0;
                      }

                      if (index == currIndex) {
                        scale = Tween<double>(begin: 0.92, end: 1.0)
                            .animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: const Interval(0.3, 1.0),
                              ),
                            )
                            .value;
                      } else {
                        scale = 1.0;
                      }

                      return Opacity(
                        opacity: opacity,
                        child: Transform.scale(
                          scale: scale,
                          child: Offstage(
                            offstage: offstage,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: child,
                  );
                }).toList(),
              ),
            );
          case BottomNavigationTransitionType.fadeInOut:
            return Stack(
              fit: StackFit.expand,
              children: widget.children.map((child) {
                final int index = widget.children.indexOf(child);

                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    final bool offstage;
                    final double opacity;

                    if (index == prevIndex) {
                      offstage = animation.isCompleted;
                    } else if (index == currIndex) {
                      offstage = false;
                    } else {
                      offstage = true;
                    }

                    if (index == prevIndex) {
                      opacity = Tween<double>(begin: 1.0, end: 0.0)
                          .animate(animation)
                          .value;
                    } else if (index == currIndex) {
                      opacity = Tween<double>(begin: 0.0, end: 1.0)
                          .animate(animation)
                          .value;
                    } else {
                      opacity = 1.0;
                    }

                    return Opacity(
                      opacity: opacity,
                      child: Offstage(
                        offstage: offstage,
                        child: child,
                      ),
                    );
                  },
                  child: child,
                );
              }).toList(),
            );
          default:
            throw UnimplementedError();
        }
      },
    );
  }
}
