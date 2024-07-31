import 'package:buddy_guardian/game/assets.dart';
import 'package:buddy_guardian/game/flappy_game.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';


class Background extends SpriteComponent with HasGameRef<FlappyBirdGame> {
  Background();

  @override
  Future<void> onLoad() async {
    final background = await Flame.images.load(Assets.background);
    size = gameRef.size;
    sprite = Sprite(background);
  }
}
