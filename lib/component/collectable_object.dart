import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:mini_game/component/custom_hitbox.dart';
import 'package:mini_game/component/player.dart';
import 'package:mini_game/kings_treasure.dart';

class CollectableObject extends SpriteAnimationComponent
    with HasGameRef<KingsTreasure>, CollisionCallbacks {
  final String colletctableObject;

  CollectableObject({
    required this.colletctableObject,
    required Vector2 size,
    required Vector2 position,
  }) : super(
          position: position,
          size: size,
        );

  bool _isCollected = false;
  final double stepTime = 0.1;
  final CuustomHitbox hitbox = CuustomHitbox(
    offestX: 5,
    offestY: 0,
    width: 12,
    height: 14,
  );

  @override
  FutureOr<void> onLoad() {
    add(
      RectangleHitbox(
        position: Vector2(hitbox.offestX, hitbox.offestY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    );

    animation = SpriteAnimation.fromFrameData(
      game.images
          .fromCache('Live and Coins/$colletctableObject Idle (18x14).png'),
      SpriteAnimationData.sequenced(
        amount: 10,
        stepTime: stepTime,
        textureSize: Vector2(18, 14),
      ),
    );

    return super.onLoad();
  }

  void collidingWithPLayer(Player player) {
    if (!_isCollected) {
      animation = SpriteAnimation.fromFrameData(
        game.images
            .fromCache('Live and Coins/$colletctableObject Hit (18x14).png'),
        SpriteAnimationData.sequenced(
          amount: 2,
          stepTime: stepTime,
          textureSize: Vector2(18, 14),
          loop: false,
        ),
      );
      _isCollected = true;
      player.diamonds += 1;
      Future.delayed(Duration(milliseconds: 100), () {
        removeFromParent();
      });
    }
  }
}
