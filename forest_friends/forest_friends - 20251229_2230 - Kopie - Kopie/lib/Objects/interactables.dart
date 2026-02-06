import 'package:flame/components.dart';
import 'package:forest_friends/forest_friends.dart';
import 'package:forest_friends/characters/player.dart';

// Eine abstrakte Basisklasse für alles, womit der Spieler interagieren kann, durch 'abstract' dient sie nur als Vorlage
abstract class Interactables extends SpriteComponent
    with HasGameReference<ForestFriends> {
  bool isPlayerNear = false; // Status Spieler, ob gerade in Reichweite
  double interactionDistance = 30.0; // Wie nah muss Spieler herankommen, um Interaktion auszulösen

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    game.currentLevel.registerInteractable(this); // Meldet Objekt beim Level an, damit interagiert werden kann
  }
  // Wird Objekt gelöscht, wird es sauber wieder abgemeldet
  @override
  void onRemove() {
    game.currentLevel.unregisterInteractable(this);
    super.onRemove();
  }
  // Methode wird von Objects überschrieben, um zu definieren, was genau passieren soll
  void onInteracted(Player player) {}

  // Berechnet Distanz und Annäherung von Spieler zum Objekt und löst Interaktion einmal aus
  @override
  void update(double dt) {
    super.update(dt);

    final player = game.currentLevel.player;

    final distance = position.distanceTo(player.position);

    if (distance < interactionDistance) {
      if (!isPlayerNear) {
        onInteracted(player);
      }
      isPlayerNear = true;
    } else {
      isPlayerNear = false;
    }
  }
}
