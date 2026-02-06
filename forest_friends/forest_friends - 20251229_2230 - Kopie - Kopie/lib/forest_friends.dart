import 'dart:async';
import 'dart:math' as math;

import 'package:flame_audio/flame_audio.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/extensions.dart';
import 'package:flame/experimental.dart';

import 'package:forest_friends/ui/pause_button_component.dart';
import 'package:forest_friends/characters/player.dart';
import 'package:forest_friends/Levels/level.dart';
import 'package:forest_friends/services/savegame_service.dart';


  // Hauptklasse, TapCallBacks: Ermöglicht reagieren auf KLicks/ Tags, HasCollisionDetection: Aktiviert Physik- Engine für Kollisionen
class ForestFriends extends FlameGame with TapCallbacks, HasCollisionDetection {
  late final CameraComponent cam;
  late Level currentLevel;
  late Player player;
  late SavegameService savegame;

  
  int plantsWatered = 0; //Gegossene Pflanzen
  int totalPLants = 3; // Zielwert Pflanzen
  int treesWatered = 0; //Gegossene Bäume
  int totalTrees = 3; // Zielwert Bäume
  int geerntetMais = 0; //Geernteter Mais
  int totalMais = 2; // Zielwert Mais

  bool get allTasksDone => (plantsWatered >= totalPLants) && (treesWatered >= totalTrees) && (geerntetMais >= totalMais); // Prüft, ob alle Aufgaben erledigt sind
  bool foresterToldMeLevelDone = false; // Prüft, ob der Förster uns bereits gesagt hat, dass wir fertig sind

  @override
  Color backgroundColor() => const Color(0xFF87CEEB); // Hintergrundfarbe des Canvas

  // Alle Bilder werden in den Cache geladen
  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'tree_dry.png',
      'tree_watered.png',
      'plant_dry.png',
      'plant_water.png',
      'eimer.png',
      'eimer_voll.png',
      'brunnen.png',
      'characters/player.png',
      'characters/forester.png',
      'pause.png',
      'wachstum_mais.png',
      'seed_bag.png',
    ]);

     // Audio- Dateien werden in den Cache geladen
    await FlameAudio.audioCache.loadAll([
      'woods.wav',
      'CountryBirdsong.wav',
      'footsteps.wav',
    ]);

    // Startet Hintergrundmusik und Vogelgezwitscher
    savegame = SavegameService();
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('woods.wav', volume: 0.3);
    FlameAudio.loop('CountryBirdsong.wav', volume: 0.2);

    //debugMode = true;


    // Level intialisieren, zur Spielwelt hinzufügen und warten bis es vollständig geladen ist
    currentLevel = Level();
    await add(currentLevel);
    await currentLevel.loaded;

    
    // Pause- Button (UI- Element) hinzufügen und ans Level hängen. Die hohe Priorität damit er über allem ist.
    final pauseButton = PauseButtonComponent()
      ..position = Vector2(60, 70)
      ..priority = 100;
      //..debugMode = true;
    currentLevel.add(pauseButton);

    //print("PauseButton pos = ${pauseButton.position}");

    // Kamera- System, fügt Kamera hinzu und bestimmt was Spieler sieht
    cam = CameraComponent(world: currentLevel);
    cam.viewfinder.anchor = Anchor.center;
    add(cam);

    // Berechnet Zoom- Faktor
    final zoomX = size.x / currentLevel.width;
    final zoomY = size.y / currentLevel.height;
    cam.viewfinder.zoom = math.min(zoomX, zoomY);
  
    // Startposition Kamera
    cam.viewfinder.position = Vector2(
      currentLevel.width / 2,
      currentLevel.height / 2,
    );

    cam.setBounds(
      Rectangle.fromLTWH(0, 0, currentLevel.width, currentLevel.height),
    );


    // Player
    player = currentLevel.player; 
    cam.follow(player); // Kamera folgt Spieler
    cam.viewfinder.zoom = 2.0; // Zoom auf Spieler

    // Speicherstand; Lädt Fortschritt, Position und gehaltenes Item aus lokalem Speicher
    final (savedPlants, savedTrees) = await savegame.loadProgress();
    plantsWatered = savedPlants;
    treesWatered = savedTrees;

    await FlameAudio.audioCache.load('woods.wav');

    final (x, y) = await savegame.loadPlayerPosition();
    if (x != null && y != null) {
      player.position = Vector2(x, y);
    }

    final item = await savegame.loadPlayerItem();
    player.currentItem = item;
    player.updateItemIcon(item);

    return super.onLoad();
  }

  // Reagiert auf Taps/ Klick auf Bildschirm; Berechnet Welt- Position aus Klick- POsition von Canvas
  @override
  void onTapDown(TapDownEvent event) {
    final worldPos = cam.viewfinder.transform.globalToLocal(
      event.canvasPosition,
    );
    //print("WORLD POS = $worldPos");
    player.moveTo(worldPos); // Spieler läuft dorthin
  }

  // Pause-Menü öffnen und speichert Fortschritt
  void pauseGameAndOpenMenu() {
    saveGame();
    pauseEngine();
    overlays.add('PauseMenu');
  }

  // Spiel speichern
  void saveGame() {
    savegame.savePlayerPosition(player.x, player.y);
    savegame.savePlayerItem(player.currentItem);
    savegame.saveProgress(plantsWatered, treesWatered);
  }

   // Tasks Complete anzeigen; Prüft ob alles erledigt und Spiel beendet und zeigt Erfolgs- Overlay an
  void showLevelComplete() {
  if (allTasksDone && foresterToldMeLevelDone && !overlays.isActive('TasksComplete')) {
    saveGame();
    pauseEngine();
    overlays.add('TasksComplete');
  }
}

  // Audio- Steuerung
  void stopMusic() {
    FlameAudio.bgm.stop();
  }

  void startMusic() {
    FlameAudio.bgm.play('time_for_adventure.mp3', volume: 0.3);
  }
}
