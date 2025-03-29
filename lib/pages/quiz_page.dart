import 'dart:math';
import 'package:flutter/material.dart';
import 'package:norse_flashcards/constants/dictionary.dart';
import 'package:norse_flashcards/models/flashcard.dart';

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

  @override
  void initState() {
    super.initState();
    if (!_isInitialized) {
      _initializeQuiz();
    }
  }

  void _initializeQuiz() {
    final flashcards = RuneMap.runes.entries
        .map((entry) => Flashcard.fromMap(entry.value, int.parse(entry.key)))
        .where((card) => 
          card.era.contains('Younger') && 
          card.subtype.contains('Long-Branch'))
        .toList();
    
    // Shuffle cards once
    _shuffledCards = List.from(flashcards)..shuffle(Random());
    _isInitialized = true;
    _resetQuiz();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _initializeQuiz(),
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Reset'),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
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
                        'Score: $_score / $_totalQuestions',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8.0),
                  Text(
                    'Younger Futhark',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_quizComplete) ...[
                    Text(
                      'Quiz Complete!',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Final Score: $_score / $_totalQuestions',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: _resetQuiz,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Start New Quiz'),
                    ),
                  ] else ...[
                    Text(
                      _currentCard.norse,
                      style: const TextStyle(fontSize: 120),
                    ),
                    const SizedBox(height: 40),
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
                      ..._options.map((option) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () => _checkAnswer(option),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text(option),
                        ),
                      )),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 