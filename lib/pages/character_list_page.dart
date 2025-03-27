import 'package:flutter/material.dart';
import 'package:norse_flashcards/constants/dictionary.dart';
import 'package:norse_flashcards/models/flashcard.dart';

class CharacterListPage extends StatelessWidget {
  const CharacterListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final flashcards = RuneMap.runes.entries
        .where((entry) => entry.value['era'].contains('Younger'))
        .map((entry) => Flashcard.fromMap(entry.value, int.parse(entry.key)))
        .toList()
      ..sort((a, b) => a.index.compareTo(b.index));

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          height: 40, // Adjust this value to fit your logo
          fit: BoxFit.contain,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text(
                'Younger Futhark',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.0,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final card = flashcards[index];
                  return Card(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            card.norse,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            card.english,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: flashcards.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 