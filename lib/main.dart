import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mini_game/kings_treasure.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  final game = KingsTreasure();
  runApp(
    GameWidget(game: kDebugMode ? KingsTreasure() : game),
  );
}
