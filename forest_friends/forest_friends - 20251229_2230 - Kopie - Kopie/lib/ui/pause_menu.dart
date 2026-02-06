import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:forest_friends/forest_friends.dart';
import 'package:forest_friends/Main Menue/main_menue_screen.dart';
import 'package:forest_friends/characters/player.dart';

// Das PauseMenu ist ein klassisches Flutter-Widget (Stateless), dass das visuelle Hauptmenü anzeigt und die Logik für die Buttons bereitstellt.
class PauseMenu extends StatelessWidget {
  final ForestFriends game;

  const PauseMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    // Erstellung Basis- Style für alle Buttons
    final ButtonStyle = ElevatedButton.styleFrom(backgroundColor: Colors.red, textStyle:  const TextStyle(fontFamily: 'PixelFont', fontSize: 24));
    
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            style: ButtonStyle,
            onPressed: () {
              game.overlays.remove('PauseMenu');

              FlameAudio.bgm.resume();
              game.resumeEngine();
            },
            child: const Text("Weiter"),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            style: ButtonStyle,
            onPressed: () {
              game.saveGame();
            },
            child: const Text("Speichern"),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            style: ButtonStyle,
            onPressed: () async {
              await game.savegame.saveBucketTaken(false);
              await game.savegame.savePlayerItem(PlayerItem.none);
              await game.savegame.savePlayerPosition(31.4233, 414.634);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MainMenueScreen()),
                (route) => false,
              );
            },
            child: const Text("Hauptmenü"),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            style: ButtonStyle,
            onPressed: () {
              game.pauseEngine();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MainMenueScreen()),
                (route) => false,
              );
            },
            child: const Text("Beenden"),
          ),
        ],
      ),
    );
  }
}
