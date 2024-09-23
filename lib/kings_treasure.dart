import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:mini_game/component/player.dart';
import 'package:mini_game/component/level.dart';

class KingsTreasure extends FlameGame
    with HasKeyboardHandlerComponents, TapCallbacks, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF0A082E);

  late final CameraComponent cam;

  Player player = Player(character: 'King Human');

  late JoystickComponent joystick;

  bool showJoystick = false;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    super.debugMode = true;

    await images.load('Live and Coins/Big Diamond Idle (18x14).png');

    final world = Level(player: player, levelName: 'Lvl');

    cam = CameraComponent.withFixedResolution(
        world: world, width: 1280, height: 640);

    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([
      cam,
      world,
    ]);

    if (showJoystick) {
      addController(cam);
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      observeControllers();
    }
    super.update(dt);
  }

  void addController(CameraComponent cam) {
    joystick = JoystickComponent(
        knob: SpriteComponent(
          sprite: Sprite(
            images.fromCache('HUD/joystick_knob.png'),
          ),
        ),
        background: SpriteComponent(
          sprite: Sprite(
            images.fromCache('HUD/joystick_bg.png'),
          ),
        ),
        margin: const EdgeInsets.only(
          left: 64,
          bottom: 32,
        ),
        position: Vector2(0, 0));
    cam.viewport.add(joystick);
  }

  void observeControllers() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
    }
  }
}
