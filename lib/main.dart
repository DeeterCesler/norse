import 'package:flutter/material.dart';
import 'package:norse_flashcards/models/flashcard.dart';
import 'package:norse_flashcards/services/flashcard_service.dart';
import 'package:norse_flashcards/widgets/flashcard_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Norse Runes Flashcards',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FlashcardScreen(),
    );
  }
}

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  late final FlashcardService _flashcardService;
  double _dragOffset = 0.0;
  bool _isDragging = false;
  double _dragStartX = 0.0;
  bool _isAnimating = false;
  double _nextCardOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _flashcardService = FlashcardService();
  }

  void _handleDragStart(DragStartDetails details) {
    if (_isAnimating) return;
    _isDragging = true;
    _dragStartX = details.globalPosition.dx;
    setState(() {});
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isDragging || _isAnimating) return;
    
    setState(() {
      _dragOffset = details.globalPosition.dx - _dragStartX;
      // Move the next card in the opposite direction
      if (_dragOffset > 0 && _flashcardService.hasPrevious) {
        _nextCardOffset = -MediaQuery.of(context).size.width + _dragOffset;
      } else if (_dragOffset < 0 && _flashcardService.hasNext) {
        _nextCardOffset = MediaQuery.of(context).size.width + _dragOffset;
      }
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isDragging || _isAnimating) return;
    
    _isDragging = false;
    
    // If dragged more than 100 pixels, trigger navigation
    if (_dragOffset.abs() > 100) {
      if (_dragOffset > 0 && _flashcardService.hasPrevious) {
        _completeDragAnimation(false);
      } else if (_dragOffset < 0 && _flashcardService.hasNext) {
        _completeDragAnimation(true);
      } else {
        // Reset position if can't navigate
        setState(() {
          _dragOffset = 0.0;
          _nextCardOffset = 0.0;
        });
      }
    } else {
      // Reset position if not dragged far enough
      setState(() {
        _dragOffset = 0.0;
        _nextCardOffset = 0.0;
      });
    }
  }

  void _completeDragAnimation(bool forward) {
    if (_isAnimating) return;
    _isAnimating = true;

    final screenWidth = MediaQuery.of(context).size.width;
    final targetOffset = forward ? -screenWidth : screenWidth;
    final startOffset = _dragOffset;
    final startNextOffset = _nextCardOffset;
    
    // Add a small delay before starting the animation
    Future.delayed(const Duration(milliseconds: 16), () {
      final startTime = DateTime.now();

      void animate() {
        if (!_isAnimating) return;
        
        final elapsed = DateTime.now().difference(startTime).inMilliseconds;
        final progress = (elapsed / 300).clamp(0.0, 1.0);
        
        setState(() {
          _dragOffset = startOffset + (targetOffset - startOffset) * progress;
          // Keep the next card's position relative to the current card
          _nextCardOffset = startNextOffset + (0 - startNextOffset) * progress;
        });

        if (progress < 1.0) {
          Future.delayed(const Duration(milliseconds: 16), animate);
        } else {
          // Update everything in a single setState
          setState(() {
            _dragOffset = 0.0;
            _nextCardOffset = 0.0;
            if (forward) {
              _flashcardService.moveToNext();
            } else {
              _flashcardService.moveToPrevious();
            }
            _isAnimating = false;
          });
        }
      }

      animate();
    });
  }

  void _animateCardChange(bool forward) {
    if (_isAnimating) return;
    _isAnimating = true;

    final screenWidth = MediaQuery.of(context).size.width;
    setState(() {
      _dragOffset = forward ? -screenWidth : screenWidth;
      _nextCardOffset = forward ? 0 : 0;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        if (forward) {
          _flashcardService.moveToNext();
        } else {
          _flashcardService.moveToPrevious();
        }
        _dragOffset = 0.0;
        _nextCardOffset = 0.0;
        _isAnimating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Norse Runes Flashcards'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onHorizontalDragStart: _handleDragStart,
              onHorizontalDragUpdate: _handleDragUpdate,
              onHorizontalDragEnd: _handleDragEnd,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Next/Previous card
                  if ((_dragOffset > 0 && _flashcardService.hasPrevious) || 
                      (_dragOffset < 0 && _flashcardService.hasNext))
                    Transform.translate(
                      offset: Offset(_nextCardOffset, 0),
                      child: FlashcardWidget(
                        card: _dragOffset > 0 ? _flashcardService.previousCard! : _flashcardService.nextCard!,
                        showNorse: _flashcardService.showNorse,
                        onTap: () {
                          setState(() {
                            _flashcardService.toggleSide();
                          });
                        },
                        slideOffset: 0,
                      ),
                    ),
                  // Current card
                  Transform.translate(
                    offset: Offset(_dragOffset, 0),
                    child: FlashcardWidget(
                      card: _flashcardService.currentCard,
                      showNorse: _flashcardService.showNorse,
                      onTap: () {
                        setState(() {
                          _flashcardService.toggleSide();
                        });
                      },
                      slideOffset: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: _flashcardService.hasPrevious && !_isAnimating
                      ? () => _animateCardChange(false)
                      : null,
                  icon: const Icon(Icons.arrow_back),
                ),
                IconButton(
                  onPressed: _isAnimating ? null : () {
                    setState(() {
                      _flashcardService.shuffle();
                    });
                  },
                  icon: const Icon(Icons.shuffle),
                ),
                IconButton(
                  onPressed: _flashcardService.hasNext && !_isAnimating
                      ? () => _animateCardChange(true)
                      : null,
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
