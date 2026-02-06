import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class SpeechBubble extends TextBoxComponent {
  // Gibt an, ob der Sprecher der Spieler ist
  final bool isPlayer;

  // Erstellt die Sprechblase
  SpeechBubble({
    required String text,
    double maxWidth = 170,
    Color backgroundColor = const Color(0xEEFFFFFF),
    Color textColor = Colors.black,
    this.isPlayer = false, // Standardmäßig spricht Förster
  }) : super(
         text: text,
         textRenderer: TextPaint(
           style: TextStyle(
             fontSize: 9,
             color: isPlayer ? Colors.black : Colors.black,
             fontFamily: 'PixelFont',
           ),
         ),
         boxConfig: TextBoxConfig(
           maxWidth: maxWidth,
           timePerChar: 0.04, // Schreibmaschinen-Effekt
           margins: const EdgeInsets.all(8),
         ),
       );

  @override
  void drawBackground(Canvas c) {
    final rect = Rect.fromLTWH(0, 0, width, height);

    // Farben für Sprecher wählen
    final bubbleColor = isPlayer
        ? const Color.fromARGB(255, 245, 170, 99) // Spieler
        : const Color.fromARGB(255, 211, 229, 128); // Förster

    // Schatten-Effekt
    c.drawRRect(
      RRect.fromRectAndRadius(
        rect.shift(const Offset(4, 4)),
        const Radius.circular(8),
      ),
      Paint()..color = Colors.black26,
    );

    // Die Sprechblase
    c.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      Paint()..color = bubbleColor,
    );

    // Umrandung der Sprechblase
    c.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      Paint()
        ..color = isPlayer ? Colors.black : Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }
}
