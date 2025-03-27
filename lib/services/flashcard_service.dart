import 'dart:math';
import 'package:norse_flashcards/constants/dictionary.dart';
import 'package:norse_flashcards/models/flashcard.dart';

class FlashcardService {
  List<Flashcard> _flashcards = [];
  int _currentIndex = 0;
  bool _showNorse = true;

  FlashcardService() {
    _initializeFlashcards();
  }

  void _initializeFlashcards() {
    // temporarily limited to younger futhark
    _flashcards = RuneMap.runes.entries.map((entry) {
      if (entry.value['era'].contains('Younger') && entry.value['subtype'].contains('Long-Branch')) {
        return Flashcard.fromMap(entry.value, int.parse(entry.key));
      }
      return null;
    }).whereType<Flashcard>().toList();
    _shuffle();
  }

  void _shuffle() {
    final random = Random();
    for (var i = _flashcards.length - 1; i > 0; i--) {
      var j = random.nextInt(i + 1);
      var temp = _flashcards[i];
      _flashcards[i] = _flashcards[j];
      _flashcards[j] = temp;
    }
    _currentIndex = 0;
  }

  void shuffle() {
    _shuffle();
  }

  Flashcard get currentCard => _flashcards[0];
  Flashcard? get nextCard => _flashcards.length > 1 ? _flashcards[1] : null;

  bool get showNorse => _showNorse;

  void toggleSide() {
    _showNorse = !_showNorse;
  }

  void moveCardToBack() {
    if (_flashcards.isNotEmpty) {
      final card = _flashcards.removeAt(0);
      _flashcards.add(card);
      _showNorse = true;
    }
  }
} 