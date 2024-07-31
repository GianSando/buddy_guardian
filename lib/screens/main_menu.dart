import 'package:buddy_guardian/game/assets.dart';
import 'package:buddy_guardian/game/flappy_game.dart';
import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  final dynamic userData;
  final FlappyBirdGame game;
  static const String id = 'mainMenu';
  const MainMenuScreen({super.key, required this.game, this.userData});

  @override
  Widget build(BuildContext context) {
    game.pauseEngine();

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          game.overlays.remove('mainMenu');
          game.resumeEngine();
        },
        child: Container(
          padding: const EdgeInsets.all(60.0),
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.menu),
              fit: BoxFit.cover,
            ),
          ),
          child: Image.asset(Assets.message),
        ),
      ),
    );
  }
}
