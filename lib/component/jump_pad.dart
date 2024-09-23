import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:mini_game/kings_treasure.dart';

class JumpPad extends SpriteComponent
    with HasGameRef<KingsTreasure>, TapCallbacks {
  JumpPad();

  final double margin = 32;
  final double padSize = 64;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('HUD/jumpad.png'));
    position = Vector2(
      game.size.x - margin - padSize,
      game.size.y - margin - padSize,
    );
    priority = 10;

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.hasJumped = true;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.player.hasJumped = false;
    super.onTapUp(event);
  }
}
