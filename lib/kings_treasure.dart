import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:mini_game/component/jump_pad.dart';
import 'package:mini_game/component/player.dart';
import 'package:mini_game/component/level.dart';

class KingsTreasure extends FlameGame
    with HasKeyboardHandlerComponents, TapCallbacks, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF0A082E);

  late final CameraComponent cam;

  Player player = Player(character: 'King Human');

  late JoystickComponent joystick;

  late TextComponent textBox;

  bool showController = true;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    // super.debugMode = true;

    textBox = await TextComponent(
        text: 'Diamonds: ${player.diamonds}',
        position: Vector2(0, 0),
        size: Vector2(40, 40));

    final world = Level(player: player, levelName: 'Lvl');

    cam = CameraComponent.withFixedResolution(
        world: world, width: 1280, height: 640);

    cam.viewfinder.anchor = Anchor.topLeft;

    cam.viewport.add(textBox);

    addAll([
      cam,
      world,
    ]);

    if (showController) {
      addController();

      add(joystick);
      add(JumpPad());
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showController) {
      observeControllers();
    }

    textBox.text = 'Diamonds: ${player.diamonds}';

    super.update(dt);
  }

  void addController() {
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

  void _loadWorld() {}
}
