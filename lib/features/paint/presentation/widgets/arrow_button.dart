import 'package:flutter/material.dart';

class ArrowButton extends StatelessWidget {
  const ArrowButton({
    super.key,
    required this.activeIcon,
    required this.inactiveIcon,
    this.active = false,
    this.onTap,
  });

  final bool active;
  final Widget activeIcon;
  final Widget inactiveIcon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      child: InkWell(
        onTap: onTap,
        child: active ? activeIcon : inactiveIcon,
      ),
    );
  }
}
