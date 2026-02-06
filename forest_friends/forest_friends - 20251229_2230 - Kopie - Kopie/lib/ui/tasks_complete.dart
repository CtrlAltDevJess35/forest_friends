import 'package:flutter/material.dart';
import 'package:forest_friends/forest_friends.dart';

// Das TasksComplete ist ein klassisches Flutter-Widget (Stateless), das ein Nachrichtenfenster anzeigt
class TasksComplete extends StatelessWidget {
  final ForestFriends game;

  const TasksComplete({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green, width: 12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Aufgaben geschafft',
              style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'PixelFont'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Du hast dem Förster geholfen und den Wald gerettet.',
              style: TextStyle(color: Colors.white70, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'PixelFont'),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}