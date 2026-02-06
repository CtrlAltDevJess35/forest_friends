import 'package:flame/components.dart';
import 'package:forest_friends/Objects/interactables.dart';
import 'package:forest_friends/characters/player.dart';


class SeedBag extends Interactables {
  bool _isPickedUp = false;


  SeedBag({required Vector2 position, Vector2? size}) {
    this.position = position;
    this.size = size ?? Vector2(32, 32);
    anchor = Anchor.center;
  }

 @override
  Future<void> onLoad() async {
    // Prüft, ob der Beutel laut Savegame schon weg ist
    final taken = await game.savegame.loadSeedsTaken(); 
    
    if (taken) {
      removeFromParent();
      return;
    }

    // Sprite laden
    sprite = await game.loadSprite('seed_bag.png');
    //scale = Vector2.all(1.0);
    priority = 10;


    return super.onLoad();
  }

  // Interaktion 
  @override
  void onInteracted(Player player) {
    if (_isPickedUp) return;
    // Nur aufheben, wenn die Hände frei sind
    if (player.currentItem == PlayerItem.none) {
      _isPickedUp = true;
      player.updateItemIcon(PlayerItem.seeds);

      // Im Savegame speichern: Beutel ist weg, Spieler hat Seeds
      game.savegame.saveSeedsTaken(true).then((_) {
      game.savegame.savePlayerItem(PlayerItem.seeds);

      removeFromParent();
    });
  }
  }
}