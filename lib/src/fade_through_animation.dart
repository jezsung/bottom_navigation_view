import 'package:flutter/widgets.dart';

class FadeThroughAnimation extends StatelessWidget {
  FadeThroughAnimation({
    Key? key,
    required this.controller,
    required this.outgoingChild,
    required this.ingoingChild,
  })   : outgoingOpacity = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.3),
          ),
        ),
        ingoingOpacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.3, 1.0),
          ),
        ),
        ingoingScale = Tween<double>(
          begin: 0.92,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.3, 1.0),
          ),
        ),
        super(key: key);

  final AnimationController controller;
  final Animation<double> outgoingOpacity;
  final Animation<double> ingoingOpacity;
  final Animation<double> ingoingScale;
  final Widget outgoingChild;
  final Widget ingoingChild;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Opacity(
              opacity: outgoingOpacity.value,
              child: outgoingChild,
            ),
            Opacity(
              opacity: ingoingOpacity.value,
              child: Transform.scale(
                scale: ingoingScale.value,
                child: ingoingChild,
              ),
            ),
          ],
        );
      },
    );
  }
}
