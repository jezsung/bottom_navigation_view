import 'package:flutter/widgets.dart';

@immutable
class BottomNavigationValue {
  const BottomNavigationValue({
    this.previousIndex,
    this.currentIndex = 0,
  }) : assert(previousIndex != currentIndex);

  final int? previousIndex;
  final int currentIndex;

  BottomNavigationValue copyWith({
    int? previousIndex,
    int? currentIndex,
  }) {
    return BottomNavigationValue(
      previousIndex: previousIndex ?? this.previousIndex,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BottomNavigationValue && other.previousIndex == previousIndex && other.currentIndex == currentIndex;
  }

  @override
  int get hashCode => hashValues(
        previousIndex.hashCode,
        currentIndex.hashCode,
      );
}
