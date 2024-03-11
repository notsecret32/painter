import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CancelButton extends ConsumerWidget {
  const CancelButton({
    super.key,
    required this.icon,
    required this.text,
    this.active = false,
    this.style,
    this.onTap,
  });

  final Widget icon;
  final String text;
  final bool active;
  final TextStyle? style;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: active ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Column(
          children: <Widget>[
            icon,
            const SizedBox(
              height: 4,
            ),
            Text(
              text,
              style: active
                  ? style?.copyWith(
                      color: Colors.black,
                    )
                  : style?.copyWith(
                      color: const Color(0xFF7D7D7D),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
