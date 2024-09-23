import 'package:mini_game/component/collision_block.dart';
import 'package:mini_game/component/player.dart';

bool checkCollision(Player player, CollisionBlock block) {
  final hitbox = player.hitbox;
  final playerX = player.position.x + hitbox.offestX;
  final playerY = player.position.y + hitbox.offestY;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final fixX = player.scale.x < 0
      ? playerX - (hitbox.offestX * 2) - playerWidth
      : playerX;
  final fixY = block.isPlatform ? playerY + playerHeight : playerY;

  return (fixY < blockY + blockHeight &&
      playerY + playerHeight > blockY &&
      fixX < blockX + blockWidth &&
      fixX + playerWidth > blockX);
}
