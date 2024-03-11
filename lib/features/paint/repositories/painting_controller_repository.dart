import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums/painting_states_enum.dart';

typedef PaintingControllerRepositoryProvider
    = StateNotifierProvider<PaintingControllerRepository, PaintingStatesEnum>;

class PaintingControllerRepository extends StateNotifier<PaintingStatesEnum> {
  PaintingControllerRepository() : super(PaintingStatesEnum.waiting);

  void setState(PaintingStatesEnum newState) {
    state = newState;
  }
}

final PaintingControllerRepositoryProvider
    paintingControllerRepositoryProvider =
    PaintingControllerRepositoryProvider((_) {
  return PaintingControllerRepository();
});
