import 'package:flutter/widgets.dart';

class CrossFadeAnimation extends StatelessWidget {
  CrossFadeAnimation({
    Key? key,
    required this.controller,
    required this.outgoingChild,
    required this.ingoingChild,
  })   : outgoingOpacity = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(controller),
        ingoingOpacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(controller),
        super(key: key);

  final AnimationController controller;
  final Animation<double> outgoingOpacity;
  final Animation<double> ingoingOpacity;
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
              child: ingoingChild,
            ),
          ],
        );
      },
    );
  }
}
