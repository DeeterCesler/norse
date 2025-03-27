import 'package:flutter/material.dart';
import 'package:norse_flashcards/services/flashcard_service.dart';
import 'package:norse_flashcards/widgets/flashcard_widget.dart';

class FlashcardPage extends StatefulWidget {
  const FlashcardPage({super.key});

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
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
      // Move the next card up as the current card moves away
      _nextCardOffset = -(_dragOffset.abs() / 5);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isDragging || _isAnimating) return;
    
    _isDragging = false;
    
    // If dragged more than 100 pixels in either direction, remove card
    if (_dragOffset.abs() > 100) {
      _completeDragAnimation();
    } else {
      // Reset position if not dragged far enough
      setState(() {
        _dragOffset = 0.0;
        _nextCardOffset = 0.0;
      });
    }
  }

  void _completeDragAnimation() {
    if (_isAnimating) return;
    _isAnimating = true;

    final screenWidth = MediaQuery.of(context).size.width;
    final targetOffset = _dragOffset > 0 ? screenWidth : -screenWidth;
    final startOffset = _dragOffset;
    final startNextOffset = _nextCardOffset;
    
    Future.delayed(const Duration(milliseconds: 16), () {
      final startTime = DateTime.now();

      void animate() {
        if (!_isAnimating) return;
        
        final elapsed = DateTime.now().difference(startTime).inMilliseconds;
        final progress = (elapsed / 300).clamp(0.0, 1.0);
        
        setState(() {
          _dragOffset = startOffset + (targetOffset - startOffset) * progress;
          _nextCardOffset = startNextOffset * (1 - progress);
        });

        if (progress < 1.0) {
          Future.delayed(const Duration(milliseconds: 16), animate);
        } else {
          setState(() {
            _dragOffset = 0.0;
            _nextCardOffset = 0.0;
            _flashcardService.moveCardToBack();
            _isAnimating = false;
          });
        }
      }

      animate();
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
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onHorizontalDragStart: _handleDragStart,
              onHorizontalDragUpdate: _handleDragUpdate,
              onHorizontalDragEnd: _handleDragEnd,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Next card
                    if (_flashcardService.nextCard != null)
                      Transform.translate(
                        offset: Offset(0, _nextCardOffset),
                        child: Center(
                          child: FlashcardWidget(
                            card: _flashcardService.nextCard!,
                            showNorse: _flashcardService.showNorse,
                            onTap: () {
                              setState(() {
                                _flashcardService.toggleSide();
                              });
                            },
                            slideOffset: 0,
                          ),
                        ),
                      ),
                    // Current card
                    Transform.translate(
                      offset: Offset(_dragOffset, 0),
                      child: Center(
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
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
              onPressed: _isAnimating ? null : () {
                setState(() {
                  _flashcardService.shuffle();
                });
              },
              icon: const Icon(Icons.shuffle),
            ),
          ),
        ],
      ),
    );
  }
} 