import 'package:flutter/material.dart';
import 'dart:math' as math;

class SwipeCard extends StatefulWidget {
  final String title;
  final String description;
  final String posterPath;
  final bool isFrontVisible;
  final Function onTap;
  final Function onSwipe;

  SwipeCard({
    required this.title,
    required this.description,
    required this.posterPath,
    this.isFrontVisible = true,
    required this.onTap,
    required this.onSwipe,
  });

  @override
  _SwipeCardState createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  late double _rotationAngle;

  @override
  void initState() {
    super.initState();
    _rotationAngle = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      onPanEnd: (details) {
        // Perform swipe action based on the user's swipe gesture
        double deltaX = details.velocity.pixelsPerSecond.dx;
        double deltaY = details.velocity.pixelsPerSecond.dy;

        if (deltaX > 0) {
          // Swiped right
          widget.onSwipe();
        } else if (deltaX < 0) {
          // Swiped left
          widget.onSwipe();
        } else if (deltaY < 0) {
          // Swiped up
          widget.onSwipe();
        }
      },
      child: AnimatedBuilder(
        animation: widget.isFrontVisible ? kAlwaysCompleteAnimation : kAlwaysDismissedAnimation,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.rotationY(_rotationAngle),
            alignment: Alignment.center,
            child: child,
          );
        },
        child: Container(
          // Your card UI here
        ),
      ),
    );
  }
}