import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'widgets/spooky_item.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
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

    // You can adjust this number to make the game easier or harder
    const int totalItems = 200; // increase from 8 - 20 or more

    final int winningIndex = rand.nextInt(totalItems);

    _items = List.generate(totalItems, (index) {
      final isWinner = index == winningIndex;

      return _ItemData(
        imagePath: isWinner
            ? 'assets/images/treasure.png'
            : _imagePaths[rand.nextInt(
                _imagePaths.length - 1,
              )], // random spooky image
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
    final screenSize = MediaQuery.of(context).size;

    return SizedBox.expand(
      // Full screen area
      child: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Animated spooky items
          ..._items.map(
            (item) => SpookyItem(
              imagePath: item.imagePath,
              onTap: () => _onItemTap(item.isWinningItem),
              screenSize: screenSize,
            ),
          ),

          // Win message overlay
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
            ),
        ],
      ),
    );
  }
}

class _ItemData {
  final String imagePath;
  final bool isWinningItem;

  _ItemData({required this.imagePath, required this.isWinningItem});
}
