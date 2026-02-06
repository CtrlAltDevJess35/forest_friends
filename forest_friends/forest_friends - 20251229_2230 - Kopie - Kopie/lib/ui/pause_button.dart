import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:forest_friends/forest_friends.dart';

class PauseButton extends PositionComponent
    with TapCallbacks, HasGameReference<ForestFriends> {
  PauseButton() : super(size: Vector2(64, 64));

  late SpriteComponent icon;

  @override
  Future<void> onLoad() async {
    // Immer über allem
    priority = 9999;

    final sprite = await Sprite.load('pause.png');

    icon = SpriteComponent(
      sprite: sprite,
      size: size,
      anchor: Anchor.topLeft,
      position: Vector2.zero(),
    );

    add(icon);

    // Button oben links
    anchor = Anchor.topLeft;
    position = Vector2(15, 15);

    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    // Immer oben links bleiben
    position = Vector2(10, 30);
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.pauseGameAndOpenMenu();
    FlameAudio.bgm.pause();
  }
}
