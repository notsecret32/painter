import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/point.dart';

typedef PointHistoryRepositoryProvider
    = StateNotifierProvider<PointHistoryRepository, List<List<Point>>>;

typedef PointHistoryRepositoryProviderRef
    = StateNotifierProviderRef<PointHistoryRepository, List<List<Point>>>;

class PointHistoryRepository extends StateNotifier<List<List<Point>>> {
  PointHistoryRepository() : super(<List<Point>>[<Point>[]]);

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void addToHistory(List<Point> points) {
    if (_currentIndex + 1 > state.length - 1) {
      state.add(points);
      _currentIndex++;
      return;
    }

    if (state[_currentIndex + 1] != points) {
      state.removeRange(_currentIndex + 1, state.length);
      state.add(points);
      _currentIndex = state.length - 1;
    }
  }

  List<Point>? undo() {
    if (_currentIndex - 1 >= 0) {
      _currentIndex--;
      return state[_currentIndex];
    }
    return null;
  }

  List<Point>? redo() {
    if (_currentIndex + 1 <= state.length - 1) {
      _currentIndex++;
      return state[_currentIndex];
    }

    return null;
  }
}

final PointHistoryRepositoryProvider pointHistoryRepositoryProvider =
    PointHistoryRepositoryProvider((_) {
  return PointHistoryRepository();
});
