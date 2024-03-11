import 'dart:math';

import 'package:flutter/material.dart';

class Point {
  Point({
    required this.x,
    required this.y,
  });

  final double x;
  final double y;

  @override
  String toString() {
    return 'Point($x, $y)';
  }

  Offset get position => Offset(x, y);

  Point copyWith({
    double? x,
    double? y,
  }) {
    return Point(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  static double distance(Point point1, Point point2) {
    final double dx = point1.x - point2.x;
    final double dy = point1.y - point2.y;
    return sqrt(dx * dx + dy * dy);
  }

  static Point fromOffset(Offset position) {
    return Point(x: position.dx, y: position.dy);
  }
}
