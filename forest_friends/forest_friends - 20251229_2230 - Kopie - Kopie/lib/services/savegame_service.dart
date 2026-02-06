import 'package:forest_friends/characters/player.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Die Klasse verwaltet Speichern und Laden aller Spieldaten
class SavegameService {
  static const _playerX = 'player_x';
  static const _playerY = 'player_y';
  static const _playerItem = 'player_item';
  static const _bucketTaken = 'bucket_taken';
  static const _seedsTaken = 'seeds_taken';
  static const _plantsWateredCount = 'plants_watered_count';
  static const _treesWateredCount = 'trees_watered_count';

  // Speichern Spielerposition
  Future<void> savePlayerPosition(double x, double y) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_playerX, x);
    await prefs.setDouble(_playerY, y);
  }
  Future<(double?, double?)> loadPlayerPosition() async {
    final prefs = await SharedPreferences.getInstance();
    final x = prefs.getDouble(_playerX);
    final y = prefs.getDouble(_playerY);
    return (x, y);
  }

  // GESAMTFORTSCHRITT SPEICHERN
  Future<void> saveProgress(int plants, int trees) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_plantsWateredCount, plants);
    await prefs.setInt(_treesWateredCount, trees);
  }

  // GESAMTFORTSCHRITT LADEN
  Future<(int, int)> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final plants = prefs.getInt(_plantsWateredCount) ?? 0;
    final trees = prefs.getInt(_treesWateredCount) ?? 0;
    return (plants, trees);
  }

  // EINZELNE PFLANZE SPEICHERN 
  // Nutzen die ID der Pflanze (z.B. "plant_1"), um ihren Status zu speichern
  Future<void> saveObjectWatered(String id, bool isWatered) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('watered_$id', isWatered);
  }

  // EINZELNE PFLANZE LADEN
  Future<bool> loadObjectWatered(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('watered_$id') ?? false;
  }
  // Dialogstatus speichern und laden
  Future<void> saveDialogState(String npcId, int state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('dialog_$npcId', state);
  }

  Future<int?> loadDialogState(String npcId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('dialog_$npcId');
  }
  // Staus Eimer speichern und laden
  Future<void> saveBucketTaken(bool taken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_bucketTaken, taken);
  }

  Future<bool> loadBucketTaken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_bucketTaken) ?? false;
  }

  // SEEDBAG SPEICHERN 
  Future<void> saveSeedsTaken(bool taken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seedsTaken, taken);
  }

  // SEEDBAG LADEN
  Future<bool> loadSeedsTaken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_seedsTaken) ?? false;
  }

  // Spielerinventar speichern und laden
  Future<void> savePlayerItem(PlayerItem item) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_playerItem, item.index);
  }

  Future<PlayerItem> loadPlayerItem() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_playerItem);
    if (index == null) return PlayerItem.none;
    return PlayerItem.values[index];
  }
  // Löschen aller Spielstände für neues Spiel
  Future<void> resetSavegame() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_playerX);
    await prefs.remove(_playerY);
    await prefs.remove(_playerItem);
    await prefs.remove(_bucketTaken);
    await prefs.remove(_seedsTaken);
    await prefs.remove(_plantsWateredCount);
    await prefs.remove(_treesWateredCount);

    final allKeys = prefs.getKeys();
    for (String key in allKeys) {
      if (key.startsWith('watered_')) {
        await prefs.remove(key);
      }
    }
    
    //print(
     // "RESET DONE: "
      //"X=${prefs.getDouble(_playerX)}, "
     // "Y=${prefs.getDouble(_playerY)}, "
     // "ITEM=${prefs.getInt(_playerItem)}, "
     // "BUCKET=${prefs.getBool(_bucketTaken)}",
    //);
  }
}
