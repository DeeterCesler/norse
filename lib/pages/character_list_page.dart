import 'package:flutter/material.dart';
import 'package:norse_flashcards/constants/dictionary.dart';
import 'package:norse_flashcards/models/flashcard.dart';

class CharacterListPage extends StatelessWidget {
  const CharacterListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final youngerLongBranch = RuneMap.runes.entries
        .where((entry) => entry.value['era'].contains('Younger') && entry.value['subtype'].contains('Long-Branch'))
        .map((entry) => Flashcard.fromMap(entry.value, int.parse(entry.key)))
        .toList()
      ..sort((a, b) => a.index.compareTo(b.index));

   final youngerShortTwig = RuneMap.runes.entries
        .where((entry) => entry.value['era'].contains('Younger') && entry.value['subtype'].contains('Short-Twig'))
        .map((entry) => Flashcard.fromMap(entry.value, int.parse(entry.key)))
        .toList()
      ..sort((a, b) => a.index.compareTo(b.index));

    final elderFuthark = RuneMap.runes.entries
        .where((entry) => entry.value['era'].contains('Elder'))
        .map((entry) => Flashcard.fromMap(entry.value, int.parse(entry.key)))
        .toList()
      ..sort((a, b) => a.index.compareTo(b.index));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Younger Futhark Long Branch Section
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Column(
                children: [
                  Text(
                    'Younger Futhark',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    'Long Branch',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
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
                  final card = youngerLongBranch[index];
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
                childCount: youngerLongBranch.length,
              ),
            ),
          ),

          // Younger Futhark Short-Twig Section
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Column(
                children: [
                  Text(
                    'Younger Futhark',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    'Short-Twig',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
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
                  final card = youngerShortTwig[index];
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
                childCount: youngerShortTwig.length,
              ),
            ),
          ),

          // Elder Futhark Section
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Column(
                children: [
                  Text(
                    'Elder Futhark',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
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
                  final card = elderFuthark[index];
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
                childCount: elderFuthark.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 