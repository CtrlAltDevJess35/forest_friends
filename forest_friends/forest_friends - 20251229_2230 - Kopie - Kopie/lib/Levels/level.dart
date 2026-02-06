import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame/components.dart';
import 'package:forest_friends/Objects/eimer.dart';
import 'package:forest_friends/Objects/brunnen.dart';
import 'package:forest_friends/Objects/feld.dart';
import 'package:forest_friends/Objects/pflanzen.dart';
import 'package:forest_friends/Objects/baum.dart';
import 'package:forest_friends/Objects/seedbag.dart';
import 'package:forest_friends/characters/player.dart';
import 'package:forest_friends/characters/forester.dart';
import 'package:forest_friends/Objects/interactables.dart';

  // Level Klasse erbt von World
class Level extends World {
  late TiledComponent map; // Repräsentiert .tmx Karte aus Tiled
  late Player player; // Referenz auf Spieler

  final List<Interactables> interactables = []; // Liste, um interaktive Objekte zu verwalten

  // Registrierung von Objekten
  void registerInteractable(Interactables i) {
    interactables.add(i);
    //print("REGISTER: ${interactables.length} Interactables");
  }
  void unregisterInteractable(Interactables i) {
    interactables.remove(i);
    //print("UNREGISTER: ${interactables.length} Interactables");
  }
  // Getter für Gesamtgröße der Karte
  double get width => map.tileMap.map.width * 16.0;
  double get height => map.tileMap.map.height * 16.0;

  Null get spawnPoint => null;

  @override
  FutureOr<void> onLoad() async {
    // Karte laden
    map = await TiledComponent.load('Forest01.tmx', Vector2.all(16));
    map.priority = -1;
    add(map);
    // Layer aus der Tiled Datei auslesen
    final spawnLayer = map.tileMap.getLayer<ObjectGroup>('Spawn');
    final collisionLayer = map.tileMap.getLayer<ObjectGroup>('Collision');
    final interactionsLayer = map.tileMap.getLayer<ObjectGroup>('Interactions');
    // Charaktere spawnen; an vorgesehen Punkten
    if (spawnLayer != null) {
      final spawnPoint = spawnLayer.objects.firstWhere(
        (o) => o.name == 'player_spawn',
        orElse: () => spawnLayer.objects.first,
      );

      final foresterPoint = spawnLayer.objects.firstWhere(
        (o) => o.name == 'forester_spawn',
        orElse: () => spawnLayer.objects.first,
      );
      // Spieler erstellen und positionieren
      player = Player();
      player.position = Vector2(spawnPoint.x, spawnPoint.y);
      player.priority = 15;
      add(player);
      player.startIntro();
      // Förster erstellen
      final forester = Forester();
      forester.position = Vector2(foresterPoint.x, foresterPoint.y);
      add(forester);
    }
    // Kollisionen auslesen und erstellen mit passiver Hitbox
    if (collisionLayer != null) {
      for (final obj in collisionLayer.objects) {
        final obstacle = PositionComponent(
          position: Vector2(obj.x, obj.y),
          size: Vector2(obj.width, obj.height),
        );
        obstacle.add(RectangleHitbox()..collisionType = CollisionType.passive);
        add(obstacle);
      }
    }
    // Interaktive Objekte erstellen und die Welt einfügen
    if (interactionsLayer != null) {
      for (final obj in interactionsLayer.objects) {
        // -------------------------
        // EIMER
        // -------------------------
        if (obj.name == 'Eimer') {
          final eimer = Eimer(
            position: Vector2(obj.x, obj.y),
            size: Vector2(obj.width, obj.height),
          );

          add(eimer);
        }

        // -------------------------
        // BRUNNEN
        // -------------------------
        if (obj.name == 'Brunnen') {
          final brunnen = Brunnen(
            position: Vector2(obj.x, obj.y),
            size: Vector2(obj.width, obj.height),
          );

          add(brunnen);
          
        }

        // -------------------------
        // PFLANZE
        // -------------------------
        if (obj.name == 'Pflanze') {
          final pflanze = Pflanzen(
            id: 'Pflanze_${obj.id}',
            position: Vector2(obj.x + obj.width / 2, obj.y + obj.height / 2),
            size: Vector2(obj.width, obj.height),
          );

          add(pflanze);
          
        }

        if (obj.name == 'Baum') {
          final baum = Baum(
            id: 'Baum_${obj.id}',
            position: Vector2(obj.x + obj.width / 2, obj.y + obj.height / 2),
            size: Vector2(obj.width, obj.height),
          );

          add(baum);
        }

        if (obj.name == 'Feld') {
          final feld = Feld(
            id: 'Feld_${obj.id}',
            position: Vector2(obj.x + obj.width / 2, obj.y + obj.height / 2),
            size: Vector2(obj.width, obj.height),
          );

          add(feld);
        }

        if (obj.name == 'seedbag') {
          final seedbag = SeedBag(
            position: Vector2(obj.x, obj.y),
            size: Vector2(obj.width, obj.height),
          );

          add(seedbag);
        }
      }
    }

    return super.onLoad();
  }
}
