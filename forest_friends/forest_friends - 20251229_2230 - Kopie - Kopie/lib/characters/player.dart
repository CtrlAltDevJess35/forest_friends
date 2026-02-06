import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:forest_friends/Objects/interactables.dart';
import 'package:forest_friends/forest_friends.dart';
import 'package:flame_audio/flame_audio.dart';

// Definition möglicher Gegenstände, die der Spieler halten kann
enum PlayerItem { none, emptyBucket, filledBucket, seeds }

// Die Player-Klasse
//  - SpriteAnimationComponent: Ermöglicht Animationen (Laufen/Stehen).
//  - CollisionCallbacks: Erlaubt dem Player, auf Kollisionen zu reagieren.
//  - HasGameReference: Gibt direkten Zugriff auf die Hauptklasse 'ForestFriends'.
class Player extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameReference<ForestFriends> {

  PlayerItem currentItem = PlayerItem.none; // Aktueller Gegenstand
  double _stepTimer = 0; // Timer für Schrittgeräusche
  final double _stepInterval = 0.4; // Intervall zwischen Schrittgeräuschen in Sekunden
  late SpriteComponent _itemIcon; // Icon zur Anzeige des gehaltenen Gegenstands
  bool _iconAdded = false; // Verfolgt, ob das Icon bereits hinzugefügt wurde
  Vector2? targetPosition; // Zielpunkt für Tap Steuerung
  double speed = 80; // Bewegungsgeschwindigkeit in Pixel pro Sekunde

  late SpriteAnimation idleAnimation; // Animation Stehen
  late SpriteAnimation walkAnimation; // Animation Laufen

  Vector2 _lastValidPosition = Vector2.zero(); // Letzte Position ohne Kollision

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Spritesheet laden und Animation erstellen
    final sheet = SpriteSheet(
      image: game.images.fromCache('characters/player.png'),
      srcSize: Vector2(32, 32),
    );

    idleAnimation = sheet.createAnimation(
      row: 0,
      stepTime: 0.3,
      from: 0,
      to: 1,
    );

    walkAnimation = sheet.createAnimation(
      row: 0,
      stepTime: 0.15,
      from: 0,
      to: 3,
    );

    animation = idleAnimation;
    size = Vector2(32, 32);
    anchor = Anchor.center;

    _lastValidPosition = position.clone();

    // Hitbox erstellen; "Active", Spieler stößt aktiv gegen was
    add(RectangleHitbox(
      size: Vector2(18, 18),
      position: Vector2(5, 5),
       collisionType: CollisionType.active,
      ));

    // Initialisierung des Icons
    _itemIcon = SpriteComponent(
      size: Vector2(16, 16),
      position: Vector2(size.x / 2, -5),
      anchor: Anchor.bottomCenter,
    );
  }

    // Reagiert auf Kollisionen
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is! Player && other is! Interactables) {
      position.setFrom(_lastValidPosition);
      targetPosition = null;
      //position = _lastValidPosition;
      animation = idleAnimation;
    }
    //print("Kollision mit: $other");
  }

    // Update- Schleife
  @override
  void update(double dt) {
    super.update(dt);
    // print("PLAYER POS = $position   TARGET = $targetPosition");
    if (targetPosition != null) {
      _lastValidPosition = position.clone();
      final direction = targetPosition! - position;
      final distance = direction.length;
        // nah genug am Ziel dann Stop
      if (distance < 1) {
        targetPosition = null;
        animation = idleAnimation;
        return;
      }

      animation = walkAnimation;

      // Schritt-Sound Logik
      _stepTimer += dt;
      if (_stepTimer >= _stepInterval) {
        _playStepSound();
        _stepTimer = 0;
      }
      // Tatsächliche Bewegung
      direction.normalize();
      position += direction * speed * dt;
    } else {
    _stepTimer = _stepInterval; // Zurücksetzen Timer beim Stehen
    }
  }

    // Aktualisiert Bild über Kopf des Spielers
  void updateItemIcon(PlayerItem item) {
    currentItem = item;
    if (!isLoaded) return;

    if (item == PlayerItem.none) {
      if (_iconAdded) {
        _itemIcon.removeFromParent();
        _iconAdded = false;
      }
      return;
    }

     // Icon laden
    if (item == PlayerItem.emptyBucket) {
      _itemIcon.sprite = Sprite(game.images.fromCache('eimer.png'));
    } else if (item == PlayerItem.filledBucket) {
      _itemIcon.sprite = Sprite(game.images.fromCache('eimer_voll.png'));
    } else if (item == PlayerItem.seeds) {
      _itemIcon.sprite = Sprite(game.images.fromCache('seed_bag.png'));
    }

    //Icon hinzufügen
    if (!_iconAdded) {
      add(_itemIcon);
      _iconAdded = true;
    }
  }

  void _playStepSound() {
    FlameAudio.play('footsteps.wav', volume: 0.4);
  }
    // Befehl laufen
  void moveTo(Vector2 target) {
    targetPosition = target;
  }
  // Gedankenbubble Spieler
  void startIntro() {
  Future.delayed(const Duration(seconds: 3), () {
    if (!isMounted) return;

    final introText = "Oh je, die Bäume und Pflanzen sehen aber trocken aus. "
        "Die brauchen bestimmt Wasser. "
        "Ah, ich seh den Förster, ich frag ihn mal, ob ich helfen kann";

    final bubble = ThoughtBubble(text: introText);
    
    // Positionierung Gedankenbubble
    bubble.position = Vector2(size.x / 2, -15); 
    bubble.anchor = Anchor.bottomCenter;
    
    add(bubble);

    // Die Bubble nach ner Zeit entfernen
    Future.delayed(const Duration(seconds: 10), () {
      if (bubble.isMounted) {
        bubble.removeFromParent();
      }
    });
  });
}
}
// Klasse für Gedankenblase
class ThoughtBubble extends TextBoxComponent with HasGameReference<ForestFriends> {
  ThoughtBubble({required String text})
      : super(
          text: text,
          size: Vector2(200, 100),
          align: Anchor.center,
          boxConfig: TextBoxConfig(
            timePerChar: 0.05,
            margins: const EdgeInsets.all(10),
          ),
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 8,
              color: Colors.black,
              fontFamily: 'PixelFont',
            ),
          ),
        );

  @override
  void render(Canvas canvas) {
    // Hintergrund der Bubble
    final rect = Rect.fromLTWH(0, 0, width, height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));
    final bgPaint = Paint()..color = Colors.redAccent.withValues(alpha: 0.9);
    canvas.drawRRect(rrect, bgPaint);

    // Umrandung der Bubble
    final borderPaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawRRect(rrect, borderPaint);

    super.render(canvas);
  }
}
