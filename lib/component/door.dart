import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:mini_game/kings_treasure.dart';

class Door extends SpriteAnimationComponent
    with HasGameRef<KingsTreasure>, CollisionCallbacks {
  final String door;
  Door({
    this.door = 'Door',
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
        );

  final double stepTime = 0.1;

  bool isOpen = false;

  @override
  FutureOr<void> onLoad() {
    add(
      RectangleHitbox(
        position: Vector2.zero(),
        size: size,
        collisionType: CollisionType.passive,
      ),
    );

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Door/Idle.png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: stepTime,
        textureSize: Vector2(46, 56),
        loop: false,
      ),
    );
    return super.onLoad();
  }

  void openDoor() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Door/Opening (46x56).png'),
      SpriteAnimationData.sequenced(
        amount: 5,
        stepTime: stepTime,
        textureSize: Vector2(46, 56),
        loop: false,
      ),
    );
  }

  void closeDoor() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Door/Closiong (46x56).png'),
      SpriteAnimationData.sequenced(
        amount: 3,
        stepTime: stepTime,
        textureSize: Vector2(46, 56),
        loop: false,
      ),
    );
  }
}
