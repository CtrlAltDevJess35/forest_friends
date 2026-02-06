import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:forest_friends/forest_friends.dart';

// Klasse, die das Bild für das Pause Menü anzeigt
class PauseButtonComponent extends SpriteComponent
    with HasGameReference<ForestFriends>, TapCallbacks {
  PauseButtonComponent() : super(size: Vector2(48, 48), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('pause.png'); // Lädt Sprite/ Icon 
    //debugMode = true; // Bounding-Box sichtbar
  }

  // Interaktion wenn Finger/ Mauszeiger losgelassen wird
  @override
  void onTapUp(TapUpEvent event) {
    game.pauseGameAndOpenMenu();
  }
}
