import 'package:flutter/widgets.dart';

import 'bottom_navigation_bar_builder.dart';
import 'bottom_navigation_body.dart';
import 'bottom_navigation_value.dart';

class BottomNavigationController extends ValueNotifier<BottomNavigationValue> {
  BottomNavigationController([this.initialIndex = 0])
      : super(
          BottomNavigationValue(currentIndex: initialIndex),
        );

  BottomNavigationController.fromValue(BottomNavigationValue? value)
      : initialIndex = value?.currentIndex ?? 0,
        super(
          value ?? BottomNavigationValue(),
        );

  /// The history of the bottom navigation.
  final List<int> history = <int>[];

  /// The initial bottom navigation index to show when the app start. This is
  /// the last index where [navigateBack] returns false.
  final int initialIndex;

  /// The current bottom navigation index.
  int get currentIndex => value.currentIndex;
  set currentIndex(int newIndex) {
    value = value.copyWith(
      previousIndex: currentIndex,
      currentIndex: newIndex,
    );
  }

  /// The previous bottom navigation index.
  int? get previousIndex => value.previousIndex;

  /// Navigates to a bottom navigation destination matched with the provided
  /// index and records to the history.
  void navigateTo(int index) {
    if (index == currentIndex) return;
    history.add(currentIndex);
    currentIndex = index;
    history.remove(currentIndex);
  }

  /// Returns true if navigating back succeeded or returns false if there is no
  /// more navigation in [history].
  bool navigateBack() {
    if (history.isNotEmpty) {
      currentIndex = history.removeLast();
      return true;
    } else if (currentIndex != initialIndex) {
      currentIndex = initialIndex;
      return true;
    } else {
      return false;
    }
  }

  static BottomNavigationController of(BuildContext context) {
    final bodyState = context.findAncestorStateOfType<BottomNavigationBodyState>();
    if (bodyState != null) {
      return bodyState.widget.controller;
    }
    final barState = context.findAncestorStateOfType<BottomNavigationBarBuilderState>();
    if (barState != null) {
      return barState.widget.controller;
    }
    throw StateError(
      'There must be at least one BottomNavigationBody or BottomNavigationBarBuilder in the acenstors of this widget.',
    );
  }

  static BottomNavigationController? maybeOf(BuildContext context) {
    final bodyState = context.findAncestorStateOfType<BottomNavigationBodyState>();
    if (bodyState != null) {
      return bodyState.widget.controller;
    }
    final barState = context.findAncestorStateOfType<BottomNavigationBarBuilderState>();
    if (barState != null) {
      return barState.widget.controller;
    }
    return null;
  }
}

class RestorableBottomNavigationController extends RestorableChangeNotifier<BottomNavigationController> {
  RestorableBottomNavigationController([this.initialIndex = 0]);

  final int initialIndex;

  @override
  BottomNavigationController createDefaultValue() {
    return BottomNavigationController(initialIndex);
  }

  @override
  BottomNavigationController fromPrimitives(Object? data) {
    return BottomNavigationController(data as int);
  }

  @override
  Object? toPrimitives() {
    return value.currentIndex;
  }
}
