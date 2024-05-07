import 'package:flutter/material.dart';
class SwipeDetector extends StatelessWidget {
  final Widget child;
  final Function onSwipeLeft;
  final Function onSwipeRight;

  const SwipeDetector({
    super.key ,
    required this.child,
    required this.onSwipeLeft,
    required this.onSwipeRight
  }) ;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! < 0) {
          onSwipeLeft();
                } else if (details.primaryVelocity! > 0) {
          onSwipeRight();
                }
      },
      child: child,
    );
  }
}