import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:forest_friends/Objects/interactables.dart';
import 'package:forest_friends/characters/player.dart';


// Klasse Baum: Erbt von Interactables (für die Spiel-Logik) und nutzt TapCallbacks (für Klicks)
class Baum extends Interactables with TapCallbacks {
  SpeechBubble? _currentBubble; // Textblase über Baum
  bool isWatered = false; // Statusabfrage: Wurde Baum gegossen?
  final String id; // ID, um Status individuell zu speichern

  Baum({required this.id, required Vector2 position, Vector2? size}) {
    this.position = position;
    this.size = size ?? Vector2(64, 64);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    // Lädt Speicherstand von jeweiligem Baum
    isWatered = await game.savegame.loadObjectWatered(id);
    // Lädt passendes Sprite basierend auf Status
    if (isWatered) {
    sprite = Sprite(game.images.fromCache('tree_watered.png'));
    } else {
      sprite = Sprite(game.images.fromCache('tree_dry.png'));
    }
    priority = 10;
  }

  // Reagiert, wenn Spieler auf Baum klickt/ tippt
  @override
  void onTapDown(TapDownEvent event) {
    final player = game.currentLevel.player;
    onInteracted(player);
  }

  @override
  Future<void> onInteracted(Player player) async {
    // Distanzprüfung
    if (position.distanceTo(player.position) < 50) {

    // Baum ist schon gegossen
    if (isWatered) {
      showSpeechBubble("Der Baum wurde bereits gegossen.");
      return;
    }

    // Spieler hat gefüllten Eimer und gießt jetzt den Baum
    if (player.currentItem == PlayerItem.filledBucket) {
      isWatered = true;
      // Bild zu gegossen wechseln
      sprite = Sprite(game.images.fromCache('tree_watered.png'));
      // Spieler hat jetzt leeren Eimer
      player.currentItem = PlayerItem.emptyBucket;
      player.updateItemIcon(PlayerItem.emptyBucket);

      // Zähler im Spiel erhöhen
      game.treesWatered++;

      // Status für den Baum und allgemeinen Fortschritt speichern
      await game.savegame.saveObjectWatered(id, true);
        await game.savegame.saveProgress(game.plantsWatered, game.treesWatered);
        game.saveGame();

        showSpeechBubble("Der Baum wurde gegossen.");
    } 
    // Spieler hat nur leeren Eimer
    else if (player.currentItem == PlayerItem.emptyBucket) {
      showSpeechBubble("Der Eimer ist leer. Fülle ihn am Brunnen.");
    } 
    // Spieler hat keinen Eimer
    else {
      showSpeechBubble("Du brauchst einen Eimer, um die Bäume zu gießen.");
    }
    }
  }

  // Erstellt Textblase über Baum und entfernt sie nach 3 Sekunden
  void showSpeechBubble(String message) {
    _currentBubble?.removeFromParent();
    _currentBubble = SpeechBubble(text: message);

    // Positionierung über Baum
    _currentBubble!.position = Vector2(size.x / 2, -10);
    _currentBubble!.anchor = Anchor.bottomCenter;

    add(_currentBubble!);

    Future.delayed(const Duration(seconds: 3), () {
      if (_currentBubble?.isMounted ?? false) {
        _currentBubble!.removeFromParent();
      }
    });
  }
}

// SpeechBubble: Textbox für kleine Nachrichten über Objekten
class SpeechBubble extends TextBoxComponent {
  SpeechBubble({required String text, double maxWidth = 70})
    : super(
        text: text,
        textRenderer: TextPaint(
          style: const TextStyle(fontSize: 8, color: Colors.black),
        ),
        boxConfig: TextBoxConfig(
          maxWidth: maxWidth,
          timePerChar: 0.05,
          margins: const EdgeInsets.all(8),
        ),
      );
    // Aussehen der SpeechBubble
  @override
  void drawBackground(Canvas c) {
    final rect = Rect.fromLTWH(0, 0, width, height);
    final paint = Paint()..color = const Color(0xEEFFFFFF);
    c.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)), paint);

    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    c.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      borderPaint,
    );
  }
}
