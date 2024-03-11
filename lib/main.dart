import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './core/theme/theme.dart';
import './features/paint/presentation/screens/paint_screen.dart';

void main() {
  runApp(const ProviderScope(child: PainterApp()));
}

class PainterApp extends StatelessWidget {
  const PainterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Painter',
      theme: theme,
      home: const PaintScreen(),
    );
  }
}
