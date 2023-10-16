import 'package:flutter/material.dart';
import 'package:flutter_animations/screens/explicit_animations_screen.dart';
import 'package:flutter_animations/screens/flashcards_screen.dart';
import 'package:flutter_animations/screens/game_store_screen.dart';
import 'package:flutter_animations/screens/implicit_animations_screen.dart';
import 'package:flutter_animations/screens/pomodoro_screen.dart';
import 'package:flutter_animations/screens/test_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _goToPage(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Animations Project'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _goToPage(
                context,
                const ImplicitAnimationsScreen(),
              ),
              child: const Text('Implicit Animations'),
            ),
            ElevatedButton(
              onPressed: () => _goToPage(
                context,
                const ExplicitAnimationsScreen(),
              ),
              child: const Text('Explicit Animations'),
            ),
            ElevatedButton(
              onPressed: () => _goToPage(
                context,
                const PomodoroScreen(),
              ),
              child: const Text('Pomodoro'),
            ),
            ElevatedButton(
              onPressed: () => _goToPage(
                context,
                const FlashcardsScreen(),
              ),
              child: const Text('Flashcards'),
            ),
            ElevatedButton(
              onPressed: () => _goToPage(
                context,
                const GameStoreScreen(),
              ),
              child: const Text('Game Store'),
            ),
            ElevatedButton(
              onPressed: () => _goToPage(
                context,
                const TestGameStoreScreen(),
              ),
              child: const Text(
                'Test Screen',
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
