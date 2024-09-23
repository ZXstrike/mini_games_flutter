import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:mini_game/component/collectable_object.dart';
import 'package:mini_game/component/collision_block.dart';
import 'package:mini_game/component/custom_hitbox.dart';
import 'package:mini_game/component/utils.dart';
import 'package:mini_game/kings_treasure.dart';

enum PlayerState { idle, running, jumping, falling, _attacking }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<KingsTreasure>, KeyboardHandler, CollisionCallbacks {
  String? character;

  Player({required this.character, position}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation _attackingAnimation;
  late final SpriteAnimation fallingAnimation;

  bool isAttacking = false;

  final double stepTime = 0.1;
  final Vector2 textureSize = Vector2(78, 58);

  final double _gravity = 9.81;
  final double _jumpForce = 360;
  final double _terminalVelocity = 350;

  double horizontalMovement = 0;
  double speed = 100;
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool hasJumped = false;

  List<CollisionBlock> collisionBlocks = [];

  CuustomHitbox hitbox = CuustomHitbox(
    offestX: 24,
    offestY: 13,
    width: 30,
    height: 32,
  );

  @override
  FutureOr<void> onLoad() {
    _onloadAllAnimations();
    debugMode = true;

    add(RectangleHitbox(
      position: Vector2(hitbox.offestX, hitbox.offestY),
      size: Vector2(hitbox.width, hitbox.height),
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    _observeHorizontalCollisions();
    _addGravity(dt);
    _observeVerticalCollisions();
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is KeyDownEvent;

    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);

    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJumped = (isKeyDown && keysPressed.contains(LogicalKeyboardKey.space)) ||
        (isKeyDown && keysPressed.contains(LogicalKeyboardKey.arrowUp));
    ;

    if (isKeyDown && event.logicalKey == LogicalKeyboardKey.keyJ) {
      isAttacking = true;
      Future.delayed(Duration(milliseconds: 100), () {
        isAttacking = false;
      });
    }

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is CollectableObject) other.collidingWithPLayer();
    super.onCollision(intersectionPoints, other);
  }

  void _onloadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle (78x58).png', 11);
    runningAnimation = _spriteAnimation('Run (78x58).png', 8);
    jumpingAnimation = _spriteAnimation('Jump (78x58).png', 1);
    _attackingAnimation = _spriteAnimation('Attack (78x58).png', 3);
    fallingAnimation = _spriteAnimation('Fall (78x58).png', 1);

    // Add all animations to the animations map
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState._attacking: _attackingAnimation,
    };

    // Set the current animation to idle
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(
    String animation_file_name,
    int amount,
  ) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('$character/$animation_file_name'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: textureSize,
      ),
    );
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    if (velocity.x != 0) playerState = PlayerState.running;

    if (velocity.y > _gravity) playerState = PlayerState.falling;

    if (velocity.y < 0) playerState = PlayerState.jumping;

    if (isAttacking) playerState = PlayerState._attacking;
    ;

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) _playerJump(dt);

    velocity.x = horizontalMovement * speed;
    position.x += velocity.x * dt;
  }

  void _observeHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.position.x - hitbox.offestX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x =
                block.position.x + block.width + hitbox.offestX + hitbox.width;
            break;
          }
        }
      }
    }
  }

  void _addGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _observeVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (velocity.y > 0) {
          if (checkCollision(this, block)) {
            velocity.y = 0;
            position.y = block.position.y - hitbox.height - hitbox.offestY;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.position.y - hitbox.offestY - hitbox.height;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.position.y - hitbox.offestY + block.height;
            break;
          }
        }
      }
    }
  }

  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _attack() {
    if (isAttacking) {
      print('Attacking');
    } else {
      print('Not Attacking');
    }
  }
}
