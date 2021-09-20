import 'package:flutter/widgets.dart';

class FadeThroughAnimation extends StatelessWidget {
  FadeThroughAnimation({
    Key? key,
    required this.animation,
    required this.outgoingChild,
    required this.ingoingChild,
  })  : ingoingOpacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Interval(0.3, 1.0),
          ),
        ),
        outgoingOpacity = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Interval(0.0, 0.3),
          ),
        ),
        ingoingScale = Tween<double>(
          begin: 0.92,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Interval(0.3, 1.0),
          ),
        ),
        super(key: key);

  final Animation<double> animation;
  final Widget ingoingChild;
  final Widget outgoingChild;
  final Animation<double> ingoingOpacity;
  final Animation<double> outgoingOpacity;
  final Animation<double> ingoingScale;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
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
