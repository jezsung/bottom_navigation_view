import 'package:flutter/widgets.dart';

class FadeInOutAnimation extends StatelessWidget {
  FadeInOutAnimation({
    Key? key,
    required this.animation,
    required this.ingoingChild,
    required this.outgoingChild,
  })  : ingoingOpacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(animation),
        outgoingOpacity = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(animation),
        super(key: key);

  final Animation<double> animation;
  final Widget ingoingChild;
  final Widget outgoingChild;
  final Animation<double> ingoingOpacity;
  final Animation<double> outgoingOpacity;

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
              child: ingoingChild,
            ),
          ],
        );
      },
    );
  }
}
