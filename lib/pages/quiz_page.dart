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
  late Flashcard _currentCard;
  late List<String> _options;
  bool _showAnswer = false;
  int _score = 0;
  int _totalQuestions = 0;

  @override
  void initState() {
    super.initState();
    _loadNewQuestion();
  }

  void _loadNewQuestion() {
    final flashcards = RuneMap.runes.entries
        .map((entry) => Flashcard.fromMap(entry.value, int.parse(entry.key)))
        .toList();

    final random = Random();
    _currentCard = flashcards[random.nextInt(flashcards.length)];
    
    // Generate options including the correct answer
    _options = [_currentCard.english];
    
    // Add 3 random incorrect options
    while (_options.length < 4) {
      final randomCard = flashcards[random.nextInt(flashcards.length)];
      if (!_options.contains(randomCard.english)) {
        _options.add(randomCard.english);
      }
    }
    
    // Shuffle options
    _options.shuffle(random);
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
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          height: 40, // Adjust this value to fit your logo
          fit: BoxFit.contain,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true, // Optional: centers the logo
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Score: $_score / $_totalQuestions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 40),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
} 