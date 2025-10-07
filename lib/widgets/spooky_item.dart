import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SpookyItem extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;
  final Size screenSize;

  const SpookyItem({
    super.key,
    required this.imagePath,
    required this.onTap,
    required this.screenSize,
  });

  @override
  State<SpookyItem> createState() => _SpookyItemState();
}

class _SpookyItemState extends State<SpookyItem> {
  late double x;
  late double y;
  final rand = Random();
  Timer? _moveTimer;

  @override
  void initState() {
    super.initState();
    _randomizePosition();

    // 🔁 Move to a new random position every few seconds
    _moveTimer = Timer.periodic(
      Duration(seconds: 1 + rand.nextInt(3)), // random interval between moves
      (_) => setState(_randomizePosition),
    );
  }

  void _randomizePosition() {
    // Keep movement inside screen boundaries
    x = rand.nextDouble() * (widget.screenSize.width - 100);
    y = rand.nextDouble() * (widget.screenSize.height - 150);
  }

  @override
  void dispose() {
    _moveTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      left: x,
      top: y,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Image.asset(widget.imagePath, width: 80),
      ),
    );
  }
}
