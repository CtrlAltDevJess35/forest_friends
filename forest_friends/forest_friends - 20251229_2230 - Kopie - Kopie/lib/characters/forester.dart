import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'package:forest_friends/Dialogue/dialogue_manager.dart';
import 'package:forest_friends/forest_friends.dart';
import 'package:forest_friends/Dialogue/speech_bubble.dart';

// Die Förster-Klasse
//  - SpriteAnimationComponent: Ermöglicht Animation (Stehen).
//  - TapCallBacks: Ermöglicht Reagieren auf Klicks/ Taps.
//  - HasGameReference: Gibt direkten Zugriff auf die Hauptklasse 'ForestFriends'.
class Forester extends SpriteAnimationComponent
    with HasGameReference<ForestFriends>, TapCallbacks {
  Forester()
    : super(
        size: Vector2(32, 32),
        anchor: Anchor.center,
      );

  // Dialog-Skript, lädt Dialog aus dialogue_manager.dart
  List<DialogueSetup> _currentScript = [];
  int _currentIndex = 0; // Verfolgt den aktuellen Schritt im Dialog
  SpeechBubble? _activeBubble; // Aktuell angezeigte Sprechblase
  bool _isPlayerNear = false; // Wichtig für die Klick-Prüfung

  @override
  Future<void> onLoad() async {
    // Sprite und Animation laden
    final spriteSheet = SpriteSheet(
      image: game.images.fromCache('characters/forester.png'),
      srcSize: Vector2(32, 32),
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.2, to: 2);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Spieler-Position abrufen
    final player = (game.currentLevel).player;
    double distance = position.distanceTo(
      player.position,
    );

    // Distanz-Check
    if (distance < 30) {
      if (!_isPlayerNear) {
        _isPlayerNear = true;
      }
    } else {
      if (_isPlayerNear) {
        _isPlayerNear = false;
        _resetDialogue(); // Dialog schließen, wenn Spieler weggeht
      }
    }
  }

  // Reagiert auf Tap-Ereignisse und startet/navigiert durch den Dialog
  @override
  void onTapDown(TapDownEvent event) {
    if (_isPlayerNear) {
      if (_currentIndex == 0 || _currentScript.isEmpty ) {
        _determineScript();
      }
      _nextStep();
    }
  }
  // Entscheidet, welchen Text der Förster basierend auf Spielfortschritt nutzt
  void _determineScript() {
    bool finished = game.allTasksDone;
    _currentScript = DialogueData.getForesterDialogue(finished);
    _currentIndex = 0;
  }

  // Steuert Dialog-Schritte
  void _nextStep() {
    _activeBubble?.removeFromParent();

    if (_currentIndex < _currentScript.length) {
      final step = _currentScript[_currentIndex];

      _activeBubble = SpeechBubble(
        text: step.text,
        isPlayer: step.speaker == Speaker.player, // Prüft, wer spricht
      );
      _activeBubble!.anchor = Anchor.bottomCenter;

      if (step.speaker == Speaker.player) {
        final player = (game.currentLevel).player;
        // Position über dem Spieler
        _activeBubble!.position = Vector2(player.size.x / 2, -15);
        player.add(_activeBubble!);
      } else {
        // Position über dem Förster
        _activeBubble!.position = Vector2(size.x / 2, -3);
        add(_activeBubble!);
      }

      _currentIndex++;
    } else {

      bool finished = game.allTasksDone;

       _resetDialogue(); // Gespräch von vorn beginnen

      if (finished) {
        game.foresterToldMeLevelDone = true;
        game.showLevelComplete();
      }
    }
  }

  // Hilfsfunktion zum Zurücksetzen des Dialogs
  void _resetDialogue() {
    _activeBubble?.removeFromParent();
    _activeBubble = null;
    _currentIndex = 0;
  }


}
