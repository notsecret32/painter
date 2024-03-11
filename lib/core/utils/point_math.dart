import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/config/settings.dart';
import '../../features/paint/models/point.dart';

double degToRad(double degrees) {
  return (degrees * math.pi) / 180;
}

double radToDeg(double radian) {
  return radian * (180 / math.pi);
}

double getLineLength(Point point1, Point point2) {
  final double dx = point2.x - point1.x;
  final double dy = point2.y - point1.y;
  return math.sqrt(dx * dx + dy * dy);
}

Point? getNearestPoint(List<Point> points, Offset position) {
  for (final Point point in points) {
    final double distance = Point.distance(point, Point.fromOffset(position));

    if (distance <= minDistanceToMerge) {
      return point;
    }
  }

  return null;
}

bool canCreateShape(
  List<Point> points, [
  double distance = minDistanceToMerge,
]) {
  return points.length >= pointsToMerge &&
      Point.distance(points.first, points.last) <= distance;
}
