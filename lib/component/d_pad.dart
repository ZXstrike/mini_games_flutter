import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:mini_game/kings_treasure.dart';

class DPad extends SpriteComponent
    with HasGameRef<KingsTreasure>, TapCallbacks {
  DPad() : super(size: Vector2(100, 100));
}
