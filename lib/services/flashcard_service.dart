import 'dart:math';
import 'package:norse_flashcards/constants/dictionary.dart';
import 'package:norse_flashcards/models/flashcard.dart';
import 'package:norse_flashcards/pages/about_page.dart';
import 'package:norse_flashcards/widgets/language_dropdown.dart';

class FlashcardService {
  // Make these static to persist between tab switches
  static List<Flashcard> _flashcards = [];
  static int _currentIndex = 0;
  static bool _showNorse = true;
  static bool _isInitialized = false;
  static RuneSet _selectedSet = RuneSet.youngerLongBranch;

  FlashcardService() {
    if (!_isInitialized) {
      _initializeFlashcards();
      _isInitialized = true;
    }
  }

  void _initializeFlashcards() {
    _updateFlashcards();
  }

  void _updateFlashcards() {
    _flashcards = RuneMap.runes.entries.map((entry) {
      if (entry.value['era'].contains(_selectedSet.era) && 
          (_selectedSet.subtype.isEmpty || entry.value['subtype'].contains(_selectedSet.subtype))) {
        return Flashcard.fromMap(entry.value, int.parse(entry.key));
      }
      return null;
    }).whereType<Flashcard>().toList();
    _shuffle();
  }

  void setRuneSet(RuneSet set) {
    if (_selectedSet != set) {
      _selectedSet = set;
      _updateFlashcards();
    }
  }

  RuneSet get selectedSet => _selectedSet;

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