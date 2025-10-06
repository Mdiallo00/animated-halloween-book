import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'widgets/spooky_item.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  final AudioPlayer _bgPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();
  bool _hasWon = false;

  final List<String> _imagePaths = [
    'assets/images/ghost.png',
    'assets/images/bat.png',
    'assets/images/pumpkin.png',
    'assets/images/treasure.png', // Winning item
  ];

  late List<_ItemData> _items;

  @override
  void initState() {
    super.initState();
    _startBackgroundMusic();
    _generateItems();
  }

  void _generateItems() {
    final rand = Random();
    _items = List.generate(8, (index) {
      final isWinner = index == rand.nextInt(8);
      return _ItemData(
        imagePath: isWinner ? 'assets/images/treasure.png' : _imagePaths[rand.nextInt(3)],
        isWinningItem: isWinner,
      );
    });
  }

  void _startBackgroundMusic() async {
    await _bgPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgPlayer.play(AssetSource('sounds/bg_music.mp3'));
  }

  void _onItemTap(bool isWinningItem) {
    if (_hasWon) return;

    if (isWinningItem) {
      _effectPlayer.play(AssetSource('sounds/win_sound.mp3'));
      setState(() => _hasWon = true);
    } else {
      _effectPlayer.play(AssetSource('sounds/trap_sound.mp3'));
    }
  }

  @override
  void dispose() {
    _bgPlayer.dispose();
    _effectPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Spooky items
        ..._items.map((item) => SpookyItem(
              imagePath: item.imagePath,
              onTap: () => _onItemTap(item.isWinningItem),
            )),
        // Win Message
        if (_hasWon)
          Center(
            child: Container(
              color: Colors.black.withOpacity(0.7),
              padding: const EdgeInsets.all(20),
              child: const Text(
                '🎉 You Found It! 🎃',
                style: TextStyle(fontSize: 32, color: Colors.orange),
              ),
            ),
          )
      ],
    );
  }
}

class _ItemData {
  final String imagePath;
  final bool isWinningItem;
  _ItemData({required this.imagePath, required this.isWinningItem});
}
