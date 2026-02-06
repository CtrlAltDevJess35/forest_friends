import 'package:flame/components.dart';
import 'package:forest_friends/Objects/interactables.dart';
import 'package:forest_friends/characters/player.dart';

// Klasse Eimer: Erbt von Interactables (für die Spiel-Logik)
class Eimer extends Interactables {
  // Setzt Position und Größe
  Eimer({required Vector2 position, Vector2? size}) {
    this.position = position;
    this.size = size ?? Vector2(16, 16);
    anchor = Anchor.topLeft;
  }

  // Lädt das Sprite und setzt die Skalierung
  @override
  Future<void> onLoad() async {
    //print("EIMER ONLOAD START");
    //final taken = await game.savegame.loadBucketTaken();
    //print("EIMER TAKEN = $taken");

    //if (taken) {
      //print("EIMER ENTFERNT WEGEN SAVEGAME");
      //removeFromParent();
      //return;
      //}

    sprite = await game.loadSprite('eimer.png');
    scale = Vector2.all(0.9);
    priority = 10;

    // Prüfen, ob der Spieler ihn laut Savegame schon hat
    final taken = await game.savegame.loadBucketTaken();
    if (taken) {
      verstecken(); // Falls geladen wird und er ist "taken", sofort weg
    }
  }

  void verstecken() {
    opacity = 0;
    position = Vector2(-1000, -1000); // Weit weg vom Spielfeld
  }


  // Interaktionslogik: Wenn der Spieler keinen Gegenstand hält, bekommt er einen leeren Eimer
  @override
  void onInteracted(Player player) {
    if (player.currentItem == PlayerItem.none) {
      player.currentItem = PlayerItem.emptyBucket;
      player.updateItemIcon(PlayerItem.emptyBucket);

      game.savegame.saveBucketTaken(true);
      game.savegame.savePlayerItem(PlayerItem.emptyBucket);
      game.saveGame();

      verstecken();

      //opacity = 0;
     // position = Vector2(-100, -100);

      //removeFromParent();
    }
  }
}
