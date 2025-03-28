import 'package:flutter/material.dart';
import 'package:norse_flashcards/pages/character_list_page.dart';
import 'package:norse_flashcards/pages/flashcard_page.dart';
import 'package:norse_flashcards/pages/quiz_page.dart';
import 'package:norse_flashcards/pages/about_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 1; // Start with flashcard page

  final List<Widget> _pages = [
    const CharacterListPage(),
    const FlashcardPage(),
    const QuizPage(),
    const AboutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
          fit: BoxFit.contain,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Characters',
          ),
          NavigationDestination(
            icon: Icon(Icons.style),
            label: 'Flashcards',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            label: 'About',
          ),
        ],
      ),
    );
  }
} 