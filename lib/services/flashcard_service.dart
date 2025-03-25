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
    _flashcards = RuneMap.runes.entries.map((entry) {
      return Flashcard.fromMap(entry.value, int.parse(entry.key));
    }).toList();
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

  Flashcard get currentCard => _flashcards[_currentIndex];
  Flashcard? get previousCard => _currentIndex > 0 ? _flashcards[_currentIndex - 1] : null;
  Flashcard? get nextCard => _currentIndex < _flashcards.length - 1 ? _flashcards[_currentIndex + 1] : null;

  bool get showNorse => _showNorse;

  void toggleSide() {
    _showNorse = !_showNorse;
  }

  void moveToNext() {
    if (_currentIndex < _flashcards.length - 1) {
      _currentIndex++;
      _showNorse = true;
    }
  }

  void moveToPrevious() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _showNorse = true;
    }
  }

  bool get hasNext => _currentIndex < _flashcards.length - 1;
  bool get hasPrevious => _currentIndex > 0;
} 