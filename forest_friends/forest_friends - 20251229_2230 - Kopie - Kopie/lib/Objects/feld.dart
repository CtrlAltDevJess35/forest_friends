import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/sprite.dart';
import 'package:flame/collisions.dart';
import 'package:forest_friends/Objects/interactables.dart';
import 'package:forest_friends/characters/player.dart';

// Klasse Feld: Erbt von Interactables (für die Spiel-Logik) und steuert Anbau und Wachstum
class Feld extends Interactables {
  final String id;
  int wachstumsPhase = 0;
  late SpriteSheet sheet;
  SpeechBubble? _currentBubble;

   Feld({required this.id, required Vector2 position, Vector2? size}) {
    this.position = position;
    this.size = size ?? Vector2(16, 16);
    anchor = Anchor.center;
    opacity = 0;
  }

  @override
  Future<void> onLoad() async {
    opacity = 0;
    await super.onLoad();
    priority = 10;
    // Spritesheet laden (3 Bilder nebeneinander)
      sheet = SpriteSheet(
      image: game.images.fromCache('wachstum_mais.png'),
      srcSize: Vector2(16, 16), // Größe eines einzelnen Bildes im Sheet
    );
    
    sprite = sheet.getSprite(0, 0); 
    
    
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }

  // Interaktion, wenn Spieler Feld anklickt/ betritt
  @override
  void onInteracted(Player player) {
    if (wachstumsPhase == 0) {
      if (player.currentItem == PlayerItem.seeds) {
        saeen(player);
      } else {
        showSpeechBubble("Ich brauche erst Saatgut!");
      }
    } else if (wachstumsPhase == 3) {
      ernten(player);
    } else {
      showSpeechBubble("Geduld... der Mais wächst noch.");
    }
  }

  // Wachstumprozess
  void saeen(Player player) {
    wachstumsPhase = 1;
    sprite = sheet.getSprite(0, 0);
    opacity = 1;
    
    player.updateItemIcon(PlayerItem.none);

    // Nach 5 Sekunden wächst Mais automatisch fertig
    add(TimerComponent(
    period: 5,
    repeat: false,
    onTick: () => wachstumsPhase2(),
    ));
  }

  void wachstumsPhase2() {
    wachstumsPhase = 2;
    sprite = sheet.getSprite(0, 1); // Zweites Bild (Mittel)
    //print("Der Mais wird größer...");

    // Finaler Wachstums-Schritt nach weiteren 5 Sekunden
    add(TimerComponent(
      period: 5,
      repeat: false,
      onTick: () => wachstumsPhase3(),
    ));
  }

  void wachstumsPhase3() {
    wachstumsPhase = 3;
    sprite = sheet.getSprite(0, 2); // Drittes Bild (Fertig)
    //print("Der Mais ist bereit zur Ernte!");
  }

  // Schließt Wachstumsprozess und zeigt Fortschritt
  void ernten(Player player) {
    //print("Mais geerntet!");
    wachstumsPhase = 0;

    game.geerntetMais++; // Globalen Zähler erhöhen
    opacity = 0;
    sprite = sheet.getSprite(0, 0);
    
    showSpeechBubble("Erfolgreich geerntet!"); // Feld wieder leer machen
    
  }
  // Erstellung Textblase und löschung nach 3 Sekunden
  void showSpeechBubble(String message) {
    _currentBubble?.removeFromParent();
    _currentBubble = SpeechBubble(text: message);

    // Positionierung über dem feld
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

// SpeechBubble/ Textblase
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


  