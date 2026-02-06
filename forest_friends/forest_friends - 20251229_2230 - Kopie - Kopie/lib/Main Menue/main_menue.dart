import 'package:flutter/material.dart';

class MainMenue extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onNewGame;

  const MainMenue({super.key, required this.onStart, required this.onNewGame});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Game_Background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withValues(alpha: 0.4),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Forest Friends',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PixelFont',
                    shadows: [
                      Shadow(offset: Offset(-5, -5), color: Colors.black),
                      Shadow(offset: Offset(5, -5), color: Colors.black),
                      Shadow(offset: Offset(5, 5), color: Colors.black),
                      Shadow(offset: Offset(5, 5), color: Colors.black),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Start Button
                SizedBox(
                  width: 250,
                  height: 70,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                    ),
                    onPressed: onStart,
                    child: const Text(
                      'Starten',
                      style: TextStyle(
                        color: Colors.green,
                        fontFamily: 'PixelFont',
                        fontSize: 24,
                        shadows: [
                          Shadow(offset: Offset(-2, -2), color: Colors.black),
                          Shadow(offset: Offset(2, -2), color: Colors.black),
                          Shadow(offset: Offset(2, 2), color: Colors.black),
                          Shadow(offset: Offset(2, 2), color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Neues Spiel Button
                SizedBox(
                  width: 250,
                  height: 70,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                    ),
                    onPressed: onNewGame,
                    child: const Text(
                      'Neues Spiel',
                      style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'PixelFont',
                        fontSize: 24,
                        shadows: [
                          Shadow(offset: Offset(-3, -3), color: Colors.black),
                          Shadow(offset: Offset(3, -3), color: Colors.black),
                          Shadow(offset: Offset(3, 3), color: Colors.black),
                          Shadow(offset: Offset(3, 3), color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Beenden Button
                SizedBox(
                  width: 250,
                  height: 70,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Beenden',
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'PixelFont',
                        fontSize: 24,
                        shadows: [
                          Shadow(offset: Offset(-3, -3), color: Colors.black),
                          Shadow(offset: Offset(3, -3), color: Colors.black),
                          Shadow(offset: Offset(3, 3), color: Colors.black),
                          Shadow(offset: Offset(3, 3), color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
