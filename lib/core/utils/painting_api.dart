import 'package:flutter/material.dart';

import '../../core/config/brushes.dart';
import '../../features/paint/models/point.dart';

class PaintingApi {
  static void setBackground(
    Canvas canvas, [
    Color color = const Color(0xFFE3E3E3),
    BlendMode blendMode = BlendMode.darken,
  ]) {
    canvas.drawColor(color, blendMode);
  }

  static void drawFilledPath(Canvas canvas, List<Point> points) {
    final Path path = _createPath(points);
    canvas.drawPath(path, whiteBrush);

    for (int i = 1; i < points.length; i++) {
      PaintingApi.drawLine(canvas, points[i - 1], points[i]);
    }
  }

  static void drawPath(Canvas canvas, List<Point> points, {bool fill = false}) {
    final Path path = _createPath(points);

    if (fill) {
      canvas.drawPath(path, whiteBrush);
    } else {
      canvas.drawPath(path, lineBrush);
    }
  }

  static void drawLine(Canvas canvas, Point start, Point end) {
    if (start != end) {
      canvas.drawLine(start.position, end.position, lineBrush);
    }
  }

  static void drawEditablePoint(Canvas canvas, Point point) {
    canvas.drawCircle(point.position, 6, whiteBrush);
    canvas.drawCircle(point.position, 4, lightBlueBrush);
  }

  static void drawNotEditablePoint(Canvas canvas, Point point) {
    canvas.drawCircle(point.position, 6, greyBrush);
    canvas.drawCircle(point.position, 5, whiteBrush);
  }

  static void drawText(
    Canvas canvas,
    String text,
    Size size,
    Offset position, [
    double radians = 0,
  ]) {
    final TextPainter textPainter = _createTextPainter(text);

    textPainter.layout(
      maxWidth: size.width,
    );

    final double dx = position.dx - (textPainter.width / 2);
    final double dy = position.dy - (textPainter.height / 2);

    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(radians);
    canvas.translate(-position.dx, -position.dy);
    textPainter.paint(canvas, Offset(dx, dy));
    canvas.restore();
  }

  static Path _createPath(List<Point> points) {
    final Path path = Path();
    path.moveTo(points.first.x, points.first.y);
    for (final Point point in points) {
      path.lineTo(point.x, point.y);
    }
    path.close();
    return path;
  }

  static TextPainter _createTextPainter(
    String text, [
    double fontSize = 11,
    Color color = const Color(0xFF0098EE),
  ]) {
    return TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          fontFamily: 'SFProText',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
  }
}
