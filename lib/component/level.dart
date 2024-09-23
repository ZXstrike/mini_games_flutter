import 'dart:async';

import 'package:flame/components.dart';

import 'package:flame_tiled/flame_tiled.dart';
import 'package:mini_game/component/collision_block.dart';
import 'package:mini_game/component/collectable_object.dart';
import 'package:mini_game/component/door.dart';
import 'package:mini_game/component/player.dart';

class Level extends World {
  final String levelName;
  final Player player;

  Level({
    required this.levelName,
    required this.player,
  });

  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(32));

    add(level);

    _addOjects();
    _addCollisions();

    return super.onLoad();
  }

  void _addOjects() {
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawnPointLayer != null) {
      for (final spawnPoint in spawnPointLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          case 'Diamond':
            final diamond = CollectableObject(
              colletctableObject: 'Big Diamond',
              size: Vector2(18, 14),
              position: Vector2(spawnPoint.x, spawnPoint.y),
            );
            add(diamond);
            break;
          case 'Door':
            final door = Door(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(46, 56),
            );
            add(door);
            break;
        }
      }
    }
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              size: Vector2(collision.width, collision.height),
              position: Vector2(collision.x, collision.y),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              size: Vector2(collision.width, collision.height),
              position: Vector2(collision.x, collision.y),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
  }
}
