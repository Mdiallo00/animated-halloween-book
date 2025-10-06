import 'package:flutter/material.dart';
import 'game_screen.dart';

void main() {
  runApp(const HalloweenApp());
}

class HalloweenApp extends StatelessWidget {
  const HalloweenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spooky Halloween Storybook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const GameScreen(),
    );
  }
}
