import 'package:flutter/material.dart';
import 'package:forest_friends/Main Menue/main_menue.dart';
import 'package:forest_friends/ui/game_screen.dart';
import 'package:forest_friends/services/savegame_service.dart';
import 'package:forest_friends/characters/player.dart';

// Der MainMenueScreen ist ein klassisches Flutter-Widget (Stateless), dass das visuelle Hauptmenü anzeigt und die Logik für die Buttons bereitstellt.
class MainMenueScreen extends StatelessWidget {
  const MainMenueScreen({super.key});

  // Laden das MainMenue-Widget und startet das Spiel und setzt es fort beim letzten Speicherstand
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainMenue(
        onStart: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GameScreen()),
          );
        },
        // Neues Spiel: Der alte Speicherstand wird gelöscht und Startwerte werden festgelegt, ebenso Startposition des Spielers wird festgelegt
        onNewGame: () async {
          final save = SavegameService();
          await save.resetSavegame();

          await save.saveBucketTaken(false);
          await save.savePlayerItem(PlayerItem.none);
          await save.savePlayerPosition(31.4233, 414.634);
          // Prüft, ob Screen noch aktiv ist
          if (!context.mounted) return;
          // Wechsel zum Spiel
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GameScreen()),
          );
        },
      ),
    );
  }
}
