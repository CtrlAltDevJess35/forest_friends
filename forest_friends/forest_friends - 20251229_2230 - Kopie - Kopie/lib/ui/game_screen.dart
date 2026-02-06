import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:forest_friends/forest_friends.dart';
import 'package:forest_friends/ui/pause_menu.dart';
import 'package:forest_friends/ui/tasks_complete.dart';

// Ein StatefulWidget, der das Spiel beherbergt.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final ForestFriends game; // Instanz Hauptspielklasse

  @override
  void initState() {
    super.initState(); // Spiel wird initialisiert
    game = ForestFriends(); // Spiel wird nur EINMAL erzeugt
  }

  // Rendert die Spielinstanz auf dem Bildschirm und definiert Ebenen, die über dem Spiel angezeigt werden können (PauseMenu/ TasksComplete)
  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: game,
      overlayBuilderMap: {
        'PauseMenu': (context, game) => PauseMenu(game: game as ForestFriends),
        'TasksComplete': (context, game) => TasksComplete(game:game as ForestFriends),
      },
    );
  }
}
