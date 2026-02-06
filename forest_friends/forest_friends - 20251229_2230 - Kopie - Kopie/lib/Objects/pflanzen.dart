import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:forest_friends/Objects/interactables.dart';
import 'package:forest_friends/characters/player.dart';

// Klasse Pflanzen erbt von Interactables und nutzt TapCallbacks für Klick/ Touch
class Pflanzen extends Interactables with TapCallbacks {
  SpeechBubble? _currentBubble; // Aktuelle Textblase über Pflanze
  bool isWatered = false; // Status, ob Pflanze schon gegossen wurde
  final String id; // ID um Status individuell zu speichern

  Pflanzen({required this.id, required Vector2 position, Vector2? size}) {
    this.position = position;
    this.size = size ?? Vector2(32, 32);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    // Lädt Zustand der Pflanze
    isWatered = await game.savegame.loadObjectWatered(id);
    // Lädt passendes Sprite
    if (isWatered) {
    sprite = Sprite(game.images.fromCache('plant_water.png'));
    } else {
      sprite = Sprite(game.images.fromCache('plant_dry.png'));
    }
    scale = Vector2.all(1.1);
    priority = 10;
    return super.onLoad();
  }

  // Interaktion, wenn Spieler Pflanze anklickt/ betritt
  @override
  void onTapDown(TapDownEvent event) {
    final player = game.currentLevel.player;
    onInteracted(player);
  }

  @override
  Future<void> onInteracted(Player player) async {
    // Distanzprüfung
    if (position.distanceTo(player.position) < 50) {

    // Pflanze ist schon gegossen
    if (isWatered) {
      showSpeechBubble("Die Pflanze wurde bereits gegossen.");
      return;
    }

    // Spieler hat gefüllten Eimer und gießt jetzt die Pflanze
    if (player.currentItem == PlayerItem.filledBucket) {
      isWatered = true;
      // Bild zu gegossen wechseln
      sprite = Sprite(game.images.fromCache('plant_water.png'));
      // Spieler hat jetzt leeren Eimer
      player.currentItem = PlayerItem.emptyBucket;
      player.updateItemIcon(PlayerItem.emptyBucket);

      game.plantsWatered++;

      // Speichern
      game.savegame.saveObjectWatered(id, true);
      game.savegame.saveProgress(game.plantsWatered, game.treesWatered);

        showSpeechBubble("Die Pflanze wurde gegossen.");
      }
     // Spieler hat nur leeren Eimer
    else if (player.currentItem == PlayerItem.emptyBucket) {
      showSpeechBubble("Der Eimer ist leer. Fülle ihn am Brunnen.");
      } 
      // Spieler hat keinen Eimer
    else {
      showSpeechBubble("Du brauchst einen Eimer, um die Pflanzen zu gießen.");
    }
    }
  }
  // Erstellung Textblase und löschung nach 3 Sekunden
  void showSpeechBubble(String message) {
    _currentBubble?.removeFromParent();
    _currentBubble = SpeechBubble(text: message);

    // Positionierung über Pflanze
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

// Klasse SpeechBubble
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
