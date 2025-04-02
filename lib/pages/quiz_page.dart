import 'dart:math';
import 'package:flutter/material.dart';
import 'package:norse_flashcards/constants/dictionary.dart';
import 'package:norse_flashcards/models/flashcard.dart';
import 'package:norse_flashcards/widgets/language_dropdown.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // Make all quiz state static to persist between tab switches
  static late List<Flashcard> _shuffledCards;
  static late Flashcard _currentCard;
  static late List<String> _options;
  static bool _showAnswer = false;
  static int _score = 0;
  static int _totalQuestions = 0;
  static Set<String> _askedRuneIds = {};
  static bool _quizComplete = false;
  static bool _isInitialized = false;  // Track if we've done initial shuffle
  static RuneSet _selectedSet = RuneSet.youngerLongBranch;

  @override
  void initState() {
    super.initState();
    if (!_isInitialized) {
      _initializeQuiz();
    }
  }

  void _initializeQuiz() {
    _updateQuizCards();
    _isInitialized = true;
  }

  void _updateQuizCards() {
    final flashcards = RuneMap.runes.entries
        .map((entry) => Flashcard.fromMap(entry.value, int.parse(entry.key)))
        .where((card) => 
          card.era.contains(_selectedSet.era) && 
          (_selectedSet.subtype.isEmpty || card.subtype.contains(_selectedSet.subtype)))
        .toList();
    
    // Shuffle cards once
    _shuffledCards = List.from(flashcards)..shuffle(Random());
    _resetQuiz();
  }

  Future<void> _showLanguageChangeDialog(RuneSet newSet) async {
    if (_totalQuestions == 0) {
      setState(() {
        setRuneSet(newSet);
      });
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Language?'),
          content: const Text('Changing the language will reset your current quiz progress. Are you sure you want to continue?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Continue'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() {
        setRuneSet(newSet);
      });
    }
  }

  void setRuneSet(RuneSet set) {
    if (_selectedSet != set) {
      _selectedSet = set;
      _updateQuizCards();
    }
  }

  void _resetQuiz() {
    setState(() {
      _askedRuneIds.clear();
      _quizComplete = false;
      _score = 0;
      _totalQuestions = 0;
      _loadNewQuestion();
    });
  }

  void _loadNewQuestion() {
    // Use the pre-shuffled cards instead of reshuffling
    final availableCards = _shuffledCards
        .where((card) => !_askedRuneIds.contains(card.norse))
        .toList();

    if (availableCards.isEmpty) {
      setState(() {
        _quizComplete = true;
      });
      return;
    }

    _currentCard = availableCards.first;  // Take the first available card
    _askedRuneIds.add(_currentCard.norse);
    
    // Generate options including the correct answer
    _options = [_currentCard.english];
    
    // Add 3 random incorrect options
    while (_options.length < 4) {
      final randomCard = _shuffledCards[Random().nextInt(_shuffledCards.length)];
      if (!_options.contains(randomCard.english)) {
        _options.add(randomCard.english);
      }
    }
    
    // Shuffle options
    _options.shuffle(Random());
    _showAnswer = false;
  }

  void _checkAnswer(String selectedAnswer) {
    setState(() {
      _showAnswer = true;
      _totalQuestions++;
      if (selectedAnswer == _currentCard.english) {
        _score++;
      }
    });
  }

  Widget _buildScoreTracker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '$_score / $_totalQuestions',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8),
                    LanguageDropdown(
                      selectedSet: _selectedSet,
                      onChanged: (set) {
                        _showLanguageChangeDialog(set);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildScoreTracker(),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_quizComplete) ...[
                      Text(
                        'Quiz Complete!',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Score: $_score / $_totalQuestions',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _resetQuiz();
                          });
                        },
                        child: const Text('Start New Quiz'),
                      ),
                    ] else ...[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 0),
                            SizedBox(
                              height: 150,
                              child: Center(
                                child: Text(
                                  _currentCard.norse,
                                  style: const TextStyle(fontSize: 120),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (_showAnswer) ...[
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  'Correct answer: ${_currentCard.english}',
                                  style: const TextStyle(fontSize: 24),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _loadNewQuestion();
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(double.infinity, 50),
                                  ),
                                  child: const Text('Next Question'),
                                ),
                              ),
                            ] else ...[
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: _options.map((option) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: ElevatedButton(
                                        onPressed: () => _checkAnswer(option),
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(double.infinity, 50),
                                        ),
                                        child: Text(option),
                                      ),
                                    )).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 