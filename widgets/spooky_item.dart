import 'dart:math';
import 'package:flutter/material.dart';

class SpookyItem extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;

  const SpookyItem({super.key, required this.imagePath, required this.onTap});

  @override
  State<SpookyItem> createState() => _SpookyItemState();
}

class _SpookyItemState extends State<SpookyItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    final random = Random();
    _controller = AnimationController(
      duration: Duration(seconds: 4 + random.nextInt(3)),
      vsync: this,
    )..repeat(reverse: true);

    _positionAnimation = Tween<Offset>(
      begin: Offset(random.nextDouble(), random.nextDouble()),
      end: Offset(random.nextDouble(), random.nextDouble()),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _positionAnimation,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Image.asset(widget.imagePath, width: 60, height: 60),
      ),
    );
  }
}
