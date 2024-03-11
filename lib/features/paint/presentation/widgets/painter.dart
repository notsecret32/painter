import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/settings.dart';
import '../../../../core/enums/painting_states_enum.dart';
import '../../../../core/utils/painting_api.dart';
import '../../../../core/utils/point_math.dart';
import '../../models/point.dart';
import '../../repositories/painting_controller_repository.dart';

class Painter extends CustomPainter {
  Painter({
    required this.ref,
    required this.points,
  });

  final WidgetRef ref;
  final List<Point> points;

  @override
  void paint(Canvas canvas, Size size) {
    PaintingApi.setBackground(canvas);

    final PaintingStatesEnum state = ref.read(
      paintingControllerRepositoryProvider,
    );

    // Рисуем линии
    for (int i = 1; i < points.length; i++) {
      PaintingApi.drawLine(canvas, points[i - 1], points[i]);

      if (canCreateShape(
        points,
        state == PaintingStatesEnum.shapeDrawn ? 1000 : minDistanceToMerge,
      )) {
        points.last = Point(x: points[0].x, y: points[0].y);
        PaintingApi.drawLine(canvas, points.last, points.first);
        PaintingApi.drawFilledPath(canvas, points);
      }
    }

    // Рисуем точки поверх линий
    for (int i = 0; i < points.length; i++) {
      state == PaintingStatesEnum.shapeDrawn
          ? PaintingApi.drawNotEditablePoint(canvas, points[i])
          : PaintingApi.drawEditablePoint(canvas, points[i]);
    }

    if (ref.read(paintingControllerRepositoryProvider) ==
        PaintingStatesEnum.shapeDrawn) {
      for (int i = 0; i < points.length; i++) {
        if (i > 0) {
          final Point previousPoint = points[i - 1];
          final Point currentPoint = points[i];
          final double lineLength = getLineLength(previousPoint, currentPoint);

          // Рассчитываем вектор направления
          final double directionX = currentPoint.x - previousPoint.x;
          final double directionY = currentPoint.y - previousPoint.y;

          // Рассчитываем позицию текста с учетом смещения наружу
          final double textOffsetX = directionY / lineLength * -10;
          final double textOffsetY = -directionX / lineLength * -10;

          final double textPosX =
              (currentPoint.x + previousPoint.x) / 2 + textOffsetX;
          final double textPosY =
              (currentPoint.y + previousPoint.y) / 2 + textOffsetY;

          final Offset textPosition = Offset(textPosX, textPosY);

          final double angle = math.atan2(directionY, directionX);

          log('#$i angle=${radToDeg(angle)}');

          // Рисуем текст
          PaintingApi.drawText(
            canvas,
            lineLength.toStringAsFixed(2),
            size,
            textPosition,
            angle,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(Painter oldDelegate) => points != oldDelegate.points;
}
