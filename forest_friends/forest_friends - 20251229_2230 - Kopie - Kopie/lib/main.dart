import 'package:flutter/material.dart';
import 'package:forest_friends/Main Menue/main_menue_screen.dart';

// Startet die Anwendung/ Spiel
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainMenueScreen(),
    ),
  );
}
