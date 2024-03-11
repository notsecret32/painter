import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums/painting_states_enum.dart';
import '../../../core/utils/point_math.dart';
import '../models/point.dart';
import '../repositories/painting_controller_repository.dart';
import '../repositories/point_history_repository.dart';

typedef PointListRepositoryProvider
    = StateNotifierProvider<PointListRepository, List<Point>>;

typedef PointListRepositoryProviderRef
    = StateNotifierProviderRef<PointListRepository, List<Point>>;

class PointListRepository extends StateNotifier<List<Point>> {
  PointListRepository({
    required PointHistoryRepository pointHistoryRepository,
    required PaintingControllerRepository paintingControllerRepository,
  })  : _pointHistoryRepository = pointHistoryRepository,
        _paintingControllerRepository = paintingControllerRepository,
        super(<Point>[]);

  final PointHistoryRepository _pointHistoryRepository;
  final PaintingControllerRepository _paintingControllerRepository;

  void addPoint(Offset position) {
    if (_paintingControllerRepository.state == PaintingStatesEnum.shapeDrawn) {
      return;
    }

    final Point? nearestPoint = getNearestPoint(state, position);

    if (nearestPoint == null) {
      state = <Point>[...state, Point.fromOffset(position)];
      _paintingControllerRepository.setState(PaintingStatesEnum.spawnPoint);
      return;
    }

    _paintingControllerRepository.setState(
      PaintingStatesEnum.updatingPositionOfAnExistingPoint,
    );
  }

  void updatePosition(Offset position) {
    final PaintingStatesEnum paintingState =
        _paintingControllerRepository.state;

    if (paintingState == PaintingStatesEnum.spawnPoint) {
      final Point spawnedPoint = state.last;
      final int index = state.indexOf(spawnedPoint);

      if (index != -1) {
        _updatePointPosition(spawnedPoint, position);
      }
    }

    if (paintingState == PaintingStatesEnum.updatingPositionOfAnExistingPoint ||
        paintingState == PaintingStatesEnum.shapeDrawn) {
      final Point? nearestPoint = getNearestPoint(state, position);

      if (nearestPoint != null) {
        _updatePointPosition(nearestPoint, position);
      }
    }
  }

  void confirm() {
    _pointHistoryRepository.addToHistory(state);

    if (canCreateShape(state)) {
      _paintingControllerRepository.setState(PaintingStatesEnum.shapeDrawn);
      return;
    }

    _paintingControllerRepository.setState(PaintingStatesEnum.waiting);
  }

  void clear() {
    state = <Point>[];
  }

  void fromList(List<Point> points) {
    state = points;
  }

  void _updatePointPosition(Point point, Offset position) {
    state = state.map((Point statePoint) {
      final Point updatedPoint = point.copyWith(
        x: position.dx,
        y: position.dy,
      );

      return statePoint == point ? updatedPoint : statePoint;
    }).toList();
  }
}

final PointListRepositoryProvider pointListRepositoryProvider =
    PointListRepositoryProvider((PointListRepositoryProviderRef ref) {
  final PaintingControllerRepository paintingRepository = ref.watch(
    paintingControllerRepositoryProvider.notifier,
  );

  final PointHistoryRepository historyRepository = ref.watch(
    pointHistoryRepositoryProvider.notifier,
  );

  return PointListRepository(
    pointHistoryRepository: historyRepository,
    paintingControllerRepository: paintingRepository,
  );
});
