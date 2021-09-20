import 'package:flutter/widgets.dart';

import 'bottom_navigation_value.dart';

class BottomNavigationController extends ValueNotifier<BottomNavigationValue> {
  BottomNavigationController({
    this.initialIndex = 0,
    required TickerProvider vsync,
    Duration duration = const Duration(milliseconds: 300),
  })  : _animationController = AnimationController(
          value: 1.0,
          vsync: vsync,
          duration: duration,
        ),
        super(
          BottomNavigationValue(currentIndex: initialIndex),
        );

  BottomNavigationController.fromValue(
    BottomNavigationValue? value, {
    required TickerProvider vsync,
    Duration duration = const Duration(milliseconds: 300),
  })  : initialIndex = value?.currentIndex ?? 0,
        _animationController = AnimationController(
          value: 1.0,
          vsync: vsync,
          duration: duration,
        ),
        super(
          value ?? BottomNavigationValue(),
        );

  final List<int> history = <int>[];
  final int initialIndex;

  final AnimationController _animationController;

  Animation<double> get animation => _animationController.view;

  int get currentIndex => value.currentIndex;
  set currentIndex(int newIndex) {
    value = value.copyWith(
      previousIndex: currentIndex,
      currentIndex: newIndex,
    );
  }

  int? get previousIndex => value.previousIndex;

  Future<void> go(int index) async {
    if (index == currentIndex) {
      return;
    }

    currentIndex = index;
    history.add(previousIndex!);
    history.remove(currentIndex);

    try {
      _animationController.reset();
      await _animationController.forward().orCancel;
    } on TickerCanceled {
      // The animation got canceled
    }
  }

  Future<void> back() async {
    if (history.isNotEmpty) {
      currentIndex = history.removeLast();
    } else if (currentIndex != initialIndex) {
      currentIndex = initialIndex;
    }

    try {
      _animationController.reset();
      await _animationController.forward().orCancel;
    } on TickerCanceled {
      // The animation got canceled
    }
  }

  @mustCallSuper
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
