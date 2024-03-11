import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/enums/painting_states_enum.dart';
import '../../models/point.dart';
import '../../repositories/painting_controller_repository.dart';
import '../../repositories/point_history_repository.dart';
import '../../repositories/point_list_repository.dart';
import '../widgets/arrow_button.dart';
import '../widgets/cancel_button.dart';

class PaintAreaOverlay extends ConsumerWidget {
  const PaintAreaOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(pointListRepositoryProvider);

    final List<List<Point>> history = ref.watch(
      pointHistoryRepositoryProvider,
    );

    log('history length: ${history.length}');

    return Stack(
      children: <Widget>[
        Positioned(
          top: 16,
          left: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: <Widget>[
                ArrowButton(
                  active: history.length > 1,
                  onTap: () async => await _undo(ref),
                  activeIcon: SvgPicture.asset(
                    'assets/images/active_arrow_left.svg',
                  ),
                  inactiveIcon: SvgPicture.asset(
                    'assets/images/arrow_left.svg',
                  ),
                ),
                Container(
                  width: 1,
                  height: 12,
                  color: const Color(0xFFC6C6C8),
                ),
                ArrowButton(
                  active: _redoButtonActiveWhen(ref),
                  onTap: () async => await _redo(ref),
                  activeIcon: SvgPicture.asset(
                    'assets/images/active_arrow_right.svg',
                  ),
                  inactiveIcon: SvgPicture.asset(
                    'assets/images/arrow_right.svg',
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          width: MediaQuery.of(context).size.width,
          bottom: 8,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double availableWidth = constraints.maxWidth;
              final TextStyle? style = Theme.of(context).textTheme.bodySmall;

              final bool isShapeDrawn = ref.watch(
                paintingControllerRepositoryProvider.select(
                  (PaintingStatesEnum state) =>
                      state == PaintingStatesEnum.shapeDrawn,
                ),
              );

              return Column(
                children: <Widget>[
                  if (!isShapeDrawn)
                    _createHintContainer(availableWidth, style),
                  const SizedBox(
                    height: 8,
                  ),
                  _createCancelContainer(
                    ref: ref,
                    active: isShapeDrawn,
                    width: availableWidth,
                    style: style,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _createHintContainer(double? width, TextStyle? style) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(11),
      child: Text(
        'Нажмите на любую точку экрана, чтобы построить угол',
        style: style,
      ),
    );
  }

  Widget _createCancelContainer({
    required WidgetRef ref,
    bool active = false,
    double? width,
    TextStyle? style,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(11),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE3E3E3),
          borderRadius: BorderRadius.circular(11),
        ),
        child: CancelButton(
          active: active,
          icon: SvgPicture.asset('assets/images/cancel.svg'),
          text: 'Отменить действие',
          style: style,
          onTap: () {
            ref.read(pointListRepositoryProvider.notifier).clear();
            ref
                .read(paintingControllerRepositoryProvider.notifier)
                .setState(PaintingStatesEnum.waiting);
          },
        ),
      ),
    );
  }

  bool _redoButtonActiveWhen(WidgetRef ref) {
    final PointHistoryRepository history =
        ref.read(pointHistoryRepositoryProvider.notifier);
    final List<List<Point>> state = ref.read(pointHistoryRepositoryProvider);

    return history.currentIndex != state.length - 1 || state.length > 1;
  }

  Future<void> _undo(WidgetRef ref) async {
    final List<Point>? points =
        ref.read(pointHistoryRepositoryProvider.notifier).undo();

    if (points != null) {
      ref.read(pointListRepositoryProvider.notifier).fromList(points);
    }
  }

  Future<void> _redo(WidgetRef ref) async {
    final List<Point>? points =
        ref.read(pointHistoryRepositoryProvider.notifier).redo();

    if (points != null) {
      ref.read(pointListRepositoryProvider.notifier).fromList(points);
    }
  }
}
