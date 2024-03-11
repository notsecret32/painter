import 'package:flutter/material.dart';

import '../widgets/paint_area.dart';

class PaintScreen extends StatelessWidget {
  const PaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 27,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFFb9b9b9),
            height: 1,
          ),
        ),
      ),
      body: const PaintArea(),
    );
  }
}
