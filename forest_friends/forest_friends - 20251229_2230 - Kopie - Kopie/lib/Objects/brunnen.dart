import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:forest_friends/Objects/interactables.dart';
import 'package:forest_friends/Objects/eimer.dart';
import 'package:forest_friends/characters/player.dart';

// Klasse Brunnen: Erbt von Interactables und nutzt TapCallbacks für Klick/ Touch
class Brunnen extends Interactables with TapCallbacks {
  SpeechBubble? _currentBubble; // Aktuelle Textblase

  Brunnen({required Vector2 position, Vector2? size}) {
    this.position = position;
    this.size = size ?? Vector2(16, 32);
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    // Lädt Sprite und erstellt eine Hitbox
    sprite = await game.loadSprite('brunnen.png');
    scale = Vector2.all(1.1);
    add(RectangleHitbox());
    priority = 10;
  }

  // Reagiert auf Klick/ Touch von Spieler
  @override
  void onTapDown(TapDownEvent event) {
    final player = game.currentLevel.player;
    onInteracted(player);
  }

 @override
  void onInteracted(Player player) async {
    if (position.distanceTo(player.position) < 60) { // Distanzprüfung

      // Eimer ist VOLL -> ABSTELLEN
      if (player.currentItem == PlayerItem.filledBucket || player.currentItem == PlayerItem.emptyBucket) {
        
        // Wir prüfen: Will der Spieler ihn gerade abstellen? 
        // Wenn er leer ist, füllen wir ihn erst. Wenn er voll ist ODER er nochmal klickt, stellen wir ab.
        if (player.currentItem == PlayerItem.filledBucket) {
          player.currentItem = PlayerItem.none;
          player.updateItemIcon(PlayerItem.none);

          // Speichert Status von Eimer und allgemeinen Fortschritt
          game.savegame.saveBucketTaken(false);
          game.savegame.savePlayerItem(PlayerItem.none);
          game.saveGame();

          // Den existierenden Eimer finden und "teleportieren"
          final eimerListe = game.currentLevel.children.query<Eimer>();
          if (eimerListe.isNotEmpty) {
            final eimer = eimerListe.first;
            eimer.position = position + Vector2(-25, 0); // Neben den Brunnen
            eimer.opacity = 1; // Wieder sichtbar machen
          }

          showSpeechBubble("Eimer am Brunnen abgestellt.");
          return;
        } 
        
        // Eimer ist LEER -> FÜLLEN
        else if (player.currentItem == PlayerItem.emptyBucket) {
          player.currentItem = PlayerItem.filledBucket;
          player.updateItemIcon(PlayerItem.filledBucket);
          game.savegame.savePlayerItem(PlayerItem.filledBucket);
          game.saveGame();
          showSpeechBubble("Eimer mit Wasser gefüllt!");
          return;
        }
      }

      //  Spieler hat Samen
      else if (player.currentItem == PlayerItem.seeds) {
        showSpeechBubble("Säe erst die Samen!");
      } 
      
      // Gar nichts
      else {
        showSpeechBubble("Du brauchst erst einen Eimer!");
      }
    }
  }

  // Erstellt Textblase über Brunnen und entfernt sie nach 3 Sekunden
  void showSpeechBubble(String message) {
    _currentBubble?.removeFromParent();
    _currentBubble = SpeechBubble(text: message);

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

// Zeichnet Aussehen der SpeechBubble
class SpeechBubble extends TextBoxComponent {
  SpeechBubble({required String text, double maxWidth = 100})
    : super(
        text: text,
        textRenderer: TextPaint(
          style: const TextStyle(fontSize: 10, color: Colors.black),
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
