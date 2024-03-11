import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/point.dart';
import '../../repositories/point_list_repository.dart';
import './paint_area_overlay.dart';
import './painter.dart';

class PaintArea extends ConsumerWidget {
  const PaintArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Point> points = ref.watch(pointListRepositoryProvider);
    final PointListRepository repository = ref.watch(
      pointListRepositoryProvider.notifier,
    );

    return GestureDetector(
      onPanStart: (DragStartDetails details) => repository.addPoint(
        details.localPosition,
      ),
      onPanUpdate: (DragUpdateDetails details) => repository.updatePosition(
        details.localPosition,
      ),
      onPanEnd: (DragEndDetails details) => repository.confirm(),
      child: CustomPaint(
        willChange: true,
        isComplex: true,
        painter: Painter(
          ref: ref,
          points: points,
        ),
        child: const PaintAreaOverlay(),
      ),
    );
  }
}
